#!/bin/bash
#
# Robin Moser, 2020
#
# Stellt eine VPN Verbindung her, hängt Samba Shares an und updatet Netzwerkeinstelungen
# Am besten zu Verwenden mit dem bash alias 'startup'

# ActiveDirectory Credentials auslesen
eval "$(sudo cat /media/.smbcredentials)"

# VPN Cli spawnen und Crednetials senden
expect -c "
	spawn -ignore HUP /opt/forticlient-sslvpn/64bit/forticlientsslvpn_cli --server sslportal.holzmann-medien.de:443 --vpnuser $username
	expect \"Password for VPN:\"
	send \"$password\r\"
	expect \"*(Y/N)\"
	send \"Y\r\"
	expect eof
"

# VPN Gateway für das Subnetz 192.168.1.0/24 löschen
# (ebenfalls mein Homeoffice Heimnetz, dadurch Konflikte)
sudo ip route delete 192.168.1.0/24 dev ppp0

# SMB-Shares anhängen, nachdem VPN Verbindung steht
sudo mount -a

# nur Ubuntu 18.04 und neuer!
# VPN Verbindung setzt eigenen DNS --> zerstört localhost Auflösung (*.local.iis)
# nmcli: resolv.conf auf ursprüngliche Hostkonfig zurücksetzen
nmcli connection up netplan-eno2

# WakeOnLan für Interface aktivieren (für Homekit Steuerung)
sudo ethtool -s eno2 wol g
