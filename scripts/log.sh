#!/bin/bash
#
# Robin Moser, 2016
#
# Wrapper für Azubi-Task-Logging
# Zu verwenden mit bash aliases

case "$2" in
    "display")
        curl -s -X POST \
            --data-urlencode "pw=$1" \
            http://scripts.azu.core.sitefusion.pdc.holzmann/log/
        ;;
    "ndisplay")
        if [[ -n $3 ]]
        then tail=$3
        else
            tail=10
        fi
        echo "letzte Logs:"
        curl -s -X POST \
            --data-urlencode "pw=$1" \
            --data-urlencode "tail=$tail" \
            http://scripts.azu.core.sitefusion.pdc.holzmann/log/
        ;;
    "write")
        while true; do
            read -p "$(date '+%d.%m.%Y - %H:%M') <LIN> " loginput
            if [[ -n $loginput ]]
            then
                curl -s -X POST \
                    --data-urlencode "pw=$1" \
                    --data-urlencode "sys=LIN" \
                    --data-urlencode "logmsg=$loginput" \
                    http://scripts.azu.core.sitefusion.pdc.holzmann/log/
            fi
        done
        ;;
    "autowrite")
        curl -s -X POST \
            --data-urlencode "pw=$1" \
            --data-urlencode "sys=LIN" \
            --data-urlencode "logmsg=$3" \
            http://scripts.azu.core.sitefusion.pdc.holzmann/log/
        ;;
    "delete")
        curl -s -X POST \
            --data-urlencode "pw=$1" \
            --data-urlencode "tail=10" \
            http://scripts.azu.core.sitefusion.pdc.holzmann/log/
        read -p "Anzahl zu löschender Logs: " rmnumber
        if [[ -n $rmnumber ]]
        then
            curl -s -X POST \
                --data-urlencode "pw=$1" \
                --data-urlencode "delete=$rmnumber" \
                http://scripts.azu.core.sitefusion.pdc.holzmann/log/
        fi
        ;;
esac
