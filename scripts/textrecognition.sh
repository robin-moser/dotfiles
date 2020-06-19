#!/bin/bash
#
# Robin Moser, 2018
#
# CLI Text erkennung durch Auswahl eines Bereiches auf dem Bildschirm
#
# Dependencies:
# sudo apt install tesseract-ocr tesseract-ocr-deu imagemagick scrot

select lang in eng deu; do break; done

SCR_IMG=$(mktemp)

echo "Jetzt Bildbereich mit der Maus auswählen!";
scrot -s "$SCR_IMG.png" -q 100

mogrify -modulate 100,0 -resize 800% "$SCR_IMG.png"

tesseract -l "$lang" "$SCR_IMG.png" "$SCR_IMG" &> /dev/null

echo

cat "$SCR_IMG.txt"

trap 'rm $SCR_IMG*' EXIT
exit
