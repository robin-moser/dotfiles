#!/bin/bash
#
# Robin Moser, 2020
#
# Fragt den hhv-aida Webservice nach dem Arbeitsstatus (eingestempelt ja/nein) und
# schreibt den Status (0:anwesend, 1:abwesend, 2:nicht erreichbar) in eine Datei
#
# - Hilfreich, um vergessenes Einstempeln im HomeOffice farbig zu markieren
# - Sollte als Cronjob alle paar Minuten ausgeführt werden

# Aidacredentials
aidacredentials="/media/.credentials.aida"

# Speichert Username, Userid, und Passwort (url encoded)
# Userid kann durch die AIDA URL des Reiters "Kontostände" herausgefunden werden
# Datei benötigt folgendes Format:
# username=myuser
# userpass=%21myencodedpassword%24
# userid=123456

sessionstore="/tmp/aida.session.id"
aidastatus="/tmp/aida.status"

aidausername=$(grep "$aidacredentials" -e username | sed 's/.*=//')
aidauserpass=$(grep "$aidacredentials" -e userpass | sed 's/.*=//')
aidauserid=$(grep "$aidacredentials" -e userid | sed 's/.*=//')

main() {
    # get aida status
    resp=$(getinfo)
    if echo "$resp" | grep -A1 Anwesend | grep ">J<" >/dev/null; then
        echo 0 > "$aidastatus"; exit
    elif echo "$resp" | grep -A1 Anwesend | grep ">N<" >/dev/null; then
        echo 1 > "$aidastatus"; exit
    elif echo "$resp" | grep "Session ist abgelaufen" >/dev/null; then
        # if parameter given, then already retried, so abort!
        test -z ${1:+x} || exit 1
        newsession
        main "retry" # recursive main, parameter to end loop
    else
        echo 2 > "$aidastatus"; exit
    fi
}

getinfo() {
    curl --silent \
        "http://hhv-aida/cgi-bin/Konten_Benutzer.html?USERID=$aidauserid&SESSION=$(getsession)"
}

getsession() {
    cat "$sessionstore"
}

newsession() {
    tempsessionid=$(curl "http://hhv-aida/cgi-bin/cgifrm1.exe" -i --silent \
        --data "__name=$aidausername&Passwort=$aidauserpass&Submit=Anmeldung&knopf=Login" | \
        grep -Eo "Konten_Benutzer.html\?USERID=$aidauserid&amp;SESSION=[0-9]+" | sed -E 's/^.*SESSION=//')

    if [ -n "$tempsessionid" ]; then
        echo "$tempsessionid" > "$sessionstore"
    fi
}

main
exit 0
