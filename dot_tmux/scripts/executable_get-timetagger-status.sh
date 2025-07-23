#!/bin/bash

bar=$1
accent=$2
primary=$3
primarytext=$4
secondary=$5
secondarytext=$6

string="$(cat /tmp/.tt-status)"

time=${string%:*}
status=${string#*:}

if [ -n "$time" ]; then

	elapsed_t="$(( $(gdate +%s) - time ))"
	elapsed_m="$(( elapsed_t / 60 ))"
	elapsed_s="$(( elapsed_t % 60 ))"

	elapsed="$(printf "%02d:%02d" $elapsed_m $elapsed_s)"

fi

[ -z "$elapsed" ] && elapsed="✖"
[ -z "$status" ] && status="Keine Erfassung"

status=${status//\#/\#[fg=$accent]\#\#}
status=${status// / \#[fg=$secondarytext]}

printf " #[fg=%s]" "$primary"

printf "#[bg=%s,fg=%s] ${elapsed} #[fg=%s,bg=%s]" \
	"$primary" "$primarytext" "$primary" "$secondary"

printf "#[fg=%s] $status #[fg=%s,bg=%s]" \
	"$secondarytext" "$secondary" "$bar"
