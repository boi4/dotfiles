#!/usr/bin/env bash

L=$(echo 'S) Š eš
s) š eš
E) Ę E nosinė
e) ę e nosinė
E) Ė ė
e) ė ė
A) Ą A nosinė
a) ą a nosinė
C) Č čė
c) č čė
i) Į I nosinė
i) į i nosinė
U) Ų U nosinė
u) ų u nosinė
U) Ū U ilgoji
u) ū u ilgoji
Z) Ž Žė
z) ž žė' | rofi -dmenu -p 'Choose letter' | awk '{print $2}' | tr -d '\n')
echo "$L" | xargs xdotool type
echo -n "$L" | xclip -selection clipboard
