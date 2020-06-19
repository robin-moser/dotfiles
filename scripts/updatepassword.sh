#!/bin/bash
#
# Robin Moser, 2019
#
# Das Skript frägt nach dem neuen Keepass-Passwort und dem AD-Passwort
# und ändert alle zugehörigen Einträge in der Passwort-Datenbank.
# Ändert zusätzlich die .smbcredentials
#
# Benötigt:
# keepassxc (sudo apt install keepassxc)
# expect (normalerweise vorinstalliert)
#
# jedes Activedirectory Passwort in der Keepass Datenbank muss
# im Notizfeld <activedirectory> stehen haben, um berücksichtigt zu werden!

set -o pipefail

db="/media/Home/Dokumente/Passwords/pwsafe.kdbx"
allentries=()
adentries=()

main() {
    passwordpromt
    promt "smbcredentials ändern?" && updatesmbpasswd
    promt "Mounts mit aktualisierten smb-Creds neu einhängen?" && sudo mount -a && echo "Erledigt!"
    setallentries ls
    setadentries
    promt "Datenbankpasswörter ändern?" && updatedatabasepasswd
}

passwordpromt() {
    read -srp $'\e[32mKeePass-Passwort:\e[0m ' -e passwd; echo
    read -srp $'\e[32m neues ActiveDirectory-Passwort:\e[0m ' -e newadpw; echo
    read -srp $'\e[32m neues ActiveDirectory-Passwort:\e[0m ' -e newadpwcheck; echo

    if [ "$newadpw" != "$newadpwcheck" ]; then
        echo "Passwörter stimmen nicht über ein, Abbruch!"
        exit 1
    fi
}

sendkeepass() {
    expect -c "
    log_user 0
    spawn -noecho keepassxc-cli $1 $db $2
    expect \"*password*\"
    send \"$passwd\r\"
    if {\"$3\" == \"changepassword\"} {
        expect \"*password*\"
        send \"$newadpw\r\"
    }
    log_user 1
    expect eof
    " | sed 's/\r$//' | tail -n +2
}

setallentries() {
    local rootlist
    rootlist=$(sendkeepass "$1" "\"$2\"")
    while IFS= read -r entry; do
        case "$entry" in
            */)
            setallentries ls "$entry" ;;
            *)
            allentries+=("$2$entry") ;;
        esac
    done <<< "$rootlist"
}

setadentries() {
    local cnt=1
    for i in "${allentries[@]}"; do
        note=$(sendkeepass "show -a Notes" "\"$i\"")
        if [[ "$note" =~ .*\<activedirectory\>.* ]]; then
            echo "Eintrag $cnt: $i"
            adentries+=("$i") && ((cnt++))
        fi
    done
}

updatedatabasepasswd() {
    for i in "${adentries[@]}"; do
        sendkeepass "edit -p" "\"$i\"" changepassword
    done
}

updatesmbpasswd() {
    echo -e "username=$USER\npassword=$newadpw" | sudo tee /media/.smbcredentials > /dev/null
}

# Fordert den User zu Bestätigung der Frage auf
#  $1 Required (string)  Auszugebende Promt-Frage
#  $2          (boolean) Defaultwert bei leerer eingabe (Standard: true)
#  $3          (string)  Farbe, in der die Frage ausgegeben wird (Standard: green)
# Returns:     0 (Antwort: yes) / 1 (Antwort no)
promt() {
    local msg=$1
    local color="${green}"
    [ -n "$3" ] && local color="$3"
    [ "$2" = false ] && local condition="[y/N]" || condition="[Y/n]"
    read -p "${color}$msg ${ncl}$condition " reply
    if [ "$2" = false ]; then
        [[ $reply =~ ^[Yy]$ ]] && return 0 || return 1
    else
        [[ $reply =~ ^[Nn]$ ]] && return 1 || return 0
    fi
}

# Überschreibt die letzte Zeile nach einem kurzen Timeout
preline() {
    sleep .2
    echo -en "\033[1A\033[2K"
}

# Promt Farben
readonly green=$'\e[0;32m'
readonly cyan=$'\e[0;36m'
readonly red=$'\e[0;31m'
readonly ncl=$'\e[0m'

main "$@"
exit 0
