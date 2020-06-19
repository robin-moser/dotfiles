#!/bin/bash
#
# Robin Moser, 2019
#
# Listet alle Elastic Chards inkl. deren Größe und Summe auf
# ! Braucht vor der Ausführung das Elasticpasswort (User elastic) als ENV Variable:
#
# export ELASTICPASSWORD=xxxxxxxxxxxx
# ./getelasticshards.sh

tmp='/tmp/.getindex.bash.tmp'
cumulativesize=0

main() {

    checkdepencies || exit 1
    getdata "$@" || exit 1
    printoutput
    getchardcount
    exit
    rm $tmp $tmp-1;
}

getdata() {
    local indexsize
    curl --silent -H 'Content-Type: application/json' -u "elastic:$ELASTICPASSWORD" \
        -XGET "http://monitoring.cloud.holzmann.priv:9200/_cat/indices$1" | sort > $tmp

    if grep $tmp -e 'security_exception' >/dev/null 2>&1; then
        printf "\nAuthentication Error:\n\n"
        cat "$tmp"
        exit 1
    fi

    indexsize=$(cat "$tmp" | awk '{ print $9 }' )

    > $tmp-1
    while read -r line; do
        humanfriendly --parse-size="$line" >> $tmp-1
    done <<< "$indexsize"
    cumulativesize=$(cat $tmp-1 | \
        awk '{ SUM += $1 } END { printf "%.f", SUM }' | \
        numfmt --to=iec)
    }

printoutput() {
    cat $tmp
    printf "\nSumme der Größe aller ausgegeben Indizes: $cumulativesize \n\n"
}

checkdepencies() {
    if ! command -v humanfriendly >/dev/null 2>&1; then
        printf "\nDas python Skript 'humanfriendly' wurde nicht gefunden.\n"
        printf "\nVersuche: pip install humanfriendly\n\n"
        return 1
    fi
}

getchardcount() {
    printf "Anzahl an Shards: "
    curl --silent -H 'Content-Type: application/json' -u "elastic:$ELASTICPASSWORD" \
        -XGET http://monitoring.cloud.holzmann.priv:9200/_cat/shards | wc -l
            echo
        }

    main "$@"
    exit 0
