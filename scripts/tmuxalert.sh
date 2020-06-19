#!/bin/bash
#
# Robin Moser, 2019
#
# Aufgerufen durch die .tmux.conf, Ausgabe von Statistiken von Aida und Mattermost.
# Startet den Mattermost-Puller (tasks/unread-mattermost) und liest Status-Files,
# um den Ausgabestatus zu bestimmen.
#
# Zeigt farbigen Hinweis bei:
# - ungelesenen Mattermost-Channels (pro Channeltyp andere Farbe)
# - Aida Stempelstatus (ausgestempelt / nicht erreichbar)
#
# Gibt Hinweis aus durch:
# - Tmux Navileiste
# - Raspberry Pi REST API (Led Steuerung am Schreibtisch)

json="/tmp/.mattermost.unread.jsons"
hidestatus="/home/moser/log/.hideleds"
statusfile="/home/moser/log/status.txt"
status=$(cat $statusfile)

main() {
    confirmrunning
    checkhidesetting
    getcount
    setstatus
    echo "Unread: $cnt_all | $aidastat"
}

confirmrunning() {
    pgrep -f "unread-mattermost" &> /dev/null
    if [[ $? == 1 ]]; then
        echo "#[bg=green,fg=black] Not started! #[bg=black]"
        nohup bash /home/moser/scripts/tasks/unread-mattermost >/dev/null 2>&1 &
        exit
    fi
}

checkhidesetting() {
    local now hide

    now=$(date '+%s')
    hide=$(cat "$hidestatus")

    diff=$(( "$now" - "$hide"))
    if [[ "$diff" -lt "90" ]]; then
        echo "#[bg=red,fg=black] Hidden"
        updatestatus "0" "0-0-0"
        exit
    fi
}

getcount() {
    IFS="|"
    cnt_all=$(getobjectcount ".")
    cnt_monitor=$(getobjectcount "${id_monitor[*]}")
    cnt_cmsproj=$(getobjectcount "${id_cmsproj[*]}")
    cnt_bmplace=$(getobjectcount "${id_bmplace[*]}")
    cnt_objects=$(getobjectcount "${id_objects[*]}")
    cnt_private=$(getobjectcount "${id_private[*]}")
    cnt_other=$(( "$cnt_all" - cnt_monitor - cnt_private - cnt_bmplace -  cnt_objects))
}

setstatus() {
    local newstat=0
    local color="0-0-0"
    local tbg="235"
    local tfg="white"

    # get AIDA Status
    aidastat=$(cat /tmp/aida.status)

    # ugelesen Monitoring Channel
    if [[ "$cnt_monitor" -gt "0" ]]; then newstat=1; tfg="white"; tbg="235"; color="0.2-0-0";    fi

    # ungelesen Objekt Channels
    if [[ "$cnt_objects" -gt "0" ]]; then newstat=2; tfg="white"; tbg="19";  color="0.1-0-0.02"; fi

    # ungelesen nicht angegebene Channels
    if [[ "$cnt_other"   -gt "0" ]]; then newstat=3; tfg="black"; tbg="166"; color="1-0.1-0";    fi

    # ungelesen Black Market Place
    if [[ "$cnt_bmplace" -gt "0" ]]; then newstat=4; tfg="black"; tbg="27";  color="0-0-1.0";    fi

    # ungelesen CMS Projekt
    if [[ "$cnt_cmsproj" -gt "0" ]]; then newstat=5; tfg="black"; tbg="149"; color="0.1-0.5-1";  fi

    # ungelesen Privatnachrichten
    if [[ "$cnt_private" -gt "0" ]]; then newstat=6; tfg="black"; tbg="41";  color="0-1-0.1";    fi

    # Aida: ausgestempelt
    if [[ "$aidastat"    ==  "1" ]]; then newstat=7; tfg="white"; tbg="1";   color="1-1-0";      fi

    # Aida: nicht erreichbar (VPN Problem)
    if [[ "$aidastat"    ==  "2" ]]; then newstat=8; tfg="white"; tbg="91";  color="1-1-0";      fi

    updatestatus "$newstat" "$color" "$tbg" "$tfg"

}

updatestatus() {
    # wenn Statuscode sich geändert hat, dann
    if [[ "$status" != "$1" ]]; then
        echo "$(date) - $1 [rest]" >> /home/moser/log/log.txt

    # Raspberry Pi REST API
    # ! im Homeoffice unnötig, daher deaktiviert
    # curl -XPOST http://192.168.52.47/status/rgb/"$2" > /dev/null

    tmux set -g status-bg "colour$3"
    tmux set -g status-fg "$4"
    echo "$1" > $statusfile
    fi
}

getobjectcount() {
    jq -s "[.[][] | select(.channel_id | test(\"$1\")).msg_count] | add" $json
}

id_monitor+=('6ypj5fc8')
id_cmsproj+=('hy5cxkn1')
id_bmplace+=('d6gydqwj')

id_objects+=('jcdmrty7') #Tophotel
id_objects+=('3f9y3cs6') #Corporate

id_private+=('78ygiihn') # behrens
id_private+=('h9ddzern') # birkle
id_private+=('fx1bht6d') # brost
id_private+=('jcdmrty7') # franz
id_private+=('thfam6hq') # franz0
id_private+=('sjxf6nz6') # gci-brandlab
id_private+=('rnax4o8m') # koob
id_private+=('thtm3jex') # kriegbaum
id_private+=('f9dnebsm') # menschner
id_private+=('sxez3m1g') # moser
id_private+=('7a9kuce8') # oez
id_private+=('8p7n5yt5') # robin
id_private+=('m9x4rh1b') # root
id_private+=('zeuenm1x') # sternberg
id_private+=('z9rfz63o') # surveybot
id_private+=('zdezqf36') # vornholt
id_private+=('nxgzntqt') # wenke
id_private+=('paaan5mb') # mayer_tim
id_private+=('dw4gx6pm') # werkhausen
id_private+=('poh6mb75') # hirsinger
id_private+=('rxy5y5dx') # kallenbach
id_private+=('ptpddkep') # gabriel_lisa
id_private+=('orehykrg') # dahlmann

main "$@"
exit 0
