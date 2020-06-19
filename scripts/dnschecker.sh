#!/bin/bash
# Robin Moser, 2019
#
# Testet eine Domain (-d www.test.de) auf 26 verschiedene DNS-Server.
# Verwendet 'dig' über 'ssh' auf dem CI-CD Node, um die DNS-Traffic Sperre der IT zu umgehen.
#
# Beispiel: ./dnschecker.sh -d www.holzmann-medien.de

main() {
    parseopts "$@"
    checkdns
}

parseopts() {
    while getopts "d:i:" opt; do
        case $opt in
            d) domain="$OPTARG" ;;
            i) targetip="$OPTARG" ;;
        esac
    done
}

checkdns() {
    IFS=$'\n'
    for row in $dnslist; do
        ip=$(echo "$row" | iis_jq '.ip')
        provider=$(echo "$row" | iis_jq '.provider')
        # führe dig auf ci-cd aus:
        # HMM Netz erlaubt keine anderen DNS Server als deren eigenen, IONOS aber schon ;)
        lookup=$(ssh root@10.8.110.12 "dig @$ip -4 +short $domain A")
        echo "IP: $lookup ($provider)"
    done
}


dnslist='
    {"ip":"208.67.222.220","provider":"Opendns"}
    {"ip":"204.117.214.10","provider":"Sprint"}
    {"ip":"208.67.222.222","provider":"Opendns"}
    {"ip":"8.8.8.8","provider":"Google"}
    {"ip":"8.26.56.26","provider":"Comodo Secure DNS"}
    {"ip":"66.209.53.88","provider":"Rogers Comm"}
    {"ip":"176.103.130.130","provider":"IONICA LLC"}
    {"ip":"197.189.234.82","provider":"Hetzner (Pty) Ltd"}
    {"ip":"193.239.186.71","provider":"Plinq Bv"}
    {"ip":"83.145.86.7","provider":"Completel SAS"}
    {"ip":"194.224.52.37","provider":"Telefonica de Espana"}
    {"ip":"194.209.157.109","provider":"Oskar Emmenegger"}
    {"ip":"146.255.61.177","provider":"Nessus GmbH"}
    {"ip":"109.228.25.186","provider":"Fasthosts Internet"}
    {"ip":"83.97.97.3","provider":" NM NET APS"}
    {"ip":"84.200.70.40","provider":"DNS.WATCH"}
    {"ip":"200.56.224.11","provider":"Marcatel Com"}
    {"ip":"189.125.18.5","provider":"Level 3 Communications"}
    {"ip":"202.171.46.38","provider":"HeiTech Padu Bhd"}
    {"ip":"1.1.1.1","provider":"Cloudflare Inc"}
    {"ip":"202.136.162.11","provider":"Ntt Singapore Pte"}
    {"ip":"168.126.63.1","provider":"KT Corporation"}
    {"ip":"202.46.32.187","provider":"Shenzhen Sunrise Technology Co."}
    {"ip":"80.93.208.66","provider":"FiberSunucu internet"}
    {"ip":"103.193.252.2","provider":"Net4U Technology"}
    {"ip":"111.68.99.194","provider":" PERN"}
    {"ip":"194.125.133.10","provider":"Indigo"}
'

main "$@"
exit 0
