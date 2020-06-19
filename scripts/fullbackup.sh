#!/bin/bash
#
# Robin Moser, 2019
#
# Interaktive Backup Prozedur, um ein Verzeichnis oder '/'
# in anderer Location zu sichern (z.B. auf einer ext. Platte)
#
# Im Zweiten Durchgang kann ein erstelltes Backup angegeben
# und symmetrisch verschlüsselt werden
#
# Schließt tempfiles, andere Volumes, proc, swap, etc. automatisch aus

set -e pipefail

main() {
    checkroot
    if promt "Backup erstellen?"; then
        selectdir
        selecttargetdir
        setbackupname
        backup
    elif promt "Bereits angelegtes Backup verschlüsseln?"; then
        selectarchive
        encryptarchive
    fi
}

checkroot() {
    if [ "$EUID" -ne 0 ]; then
        log error "Bitte als root ausführen!"
        exit 1
    fi
}

selectdir() {
    read -ep "${cyn}Zu sicherndes Verzeichnis wählen: ${end}" -i / backupdir
    preline; log info "Gewähltes Backupverzeichnis:${end} $backupdir"
    if [ ! -d "$backupdir" ];  then
        log error "Kein gültiges Verzeichnis, Abbruch!"
        exit 1
    fi
    backupdir=${backupdir#/}
    if [ -z ${backupdir} ]; then
        backupdir="."
    fi
}

selecttargetdir() {
    read -ep "${cyn}Zielpfad des Backuparchives angeben: ${end}" -i / targetdir
    preline; log info "Gewähltes Zielverzeichnis:${end} $targetdir"

    if [ ! -d "$targetdir" ]; then
        log info "Versuche, Verzeichnis $targetdir anzulegen..."
        mkdir -p "$targetdir" || ( log error "Verzeichnis konnte nicht angelegt werden, Abbruch!"; exit 1 )
        preline
        log info "Verzeichnis $targetdir angelegt"
    fi
}

setbackupname() {
    currdate=$(date --rfc-3339=date)
    filename="${targetdir%/}/backup-$currdate.tar.gz"
    filename=${filename#/}
    log info "Backupdatei:${end} $filename"
    echo
}

backup() {
    pwd
    if promt "Verzeichnis${end} $backupdir ${cyn}in Datei${end} $filename ${cyn}packen?${end}" false "$cyn"; then
        tar --one-file-system \
            --exclude-backups \
            --exclude-caches \
            --exclude=/dev/* \
            --exclude=/proc/* \
            --exclude=/sys/* \
            --exclude=/lost+found/* \
            --exclude=/tmp/* \
            --exclude=/run/* \
            --exclude=/var/run/* \
            --exclude=/var/spool/* \
            --exclude=/var/tmp/* \
            --exclude=/swap/* \
            --exclude=$filename \
            --create \
            --preserve-permissions \
            --totals \
            --gzip \
            --file "$filename" "$backupdir"
                else
                    exit 1
    fi
}

selectarchive() {
    read -ep "${cyn}Backuparchive angeben: ${end}" -i / backuparchive
    preline; log info "Gewähltes Zielverzeichnis:${end} $backuparchive"

    if [ ! -f "$backuparchive" ]; then
        log error "Archiv nicht gefunden, Abbruch!"
        exit 1
    fi
}

encryptarchive() {
    gpg -c "$backuparchive"
    echo
    if promt "Unverschlüsseltes Archiv löschen?\nDas anfangs erstellte Archiv wird nicht mehr benögigt"; then
        echo rm -vrf "$backuparchive"
    fi
}


# --------------------- #

log() {
    local EOL="\n"
    if [[ "$1" == "-e" ]]; then
        EOL=""
        shift
    fi
    level="$1"
    shift
    case $level in
        info)    printf "%b%s %b" "${cyn}" "$@" "${end}\n";;
        success) printf "%b%s %b" "${grn}" "$@" "${end}\n";;
        warning) printf "%b%s %b" "${yel}" "$@" "${end}\n";;
        error)   printf "%b%s %b" "${red}" "$@" "${end}\n";;
    esac
}

promt() {
    local msg=$1
    local color="${cyn}"
    [ -n "$3" ] && local color="$3"
    [ "$2" = false ] && local condition="[y/N]" || condition="[Y/n]"
    read -p "${color}$msg ${end}$condition " reply
    if [ "$2" = false ]; then
        [[ $reply =~ ^[Yy]$ ]] && return 0 || return 1
    else
        [[ $reply =~ ^[Nn]$ ]] && return 1 || return 0
    fi
}


preline() {
    echo -en "\033[1A\033[2K"
}

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
cyn=$'\e[1;36m'
end=$'\e[0m'

main "$@"
exit 0
