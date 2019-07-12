#!/bin/sh

#!/bin/sh

MAN=$(man -k . | dmenu -l 10 | awk '{ print $2 " " $1 }' | tr -d '()')

ACTIVE_WINDOW_ID=$(xprop -root | awk '/NET_ACTIVE_WINDOW/ { print $5; exit}')
ACTIVE_WINDOW_CLASS=$(xprop -id $ACTIVE_WINDOW_ID | awk -F\" '/WM_CLASS/ {print $2; exit}')

if [[ $ACTIVE_WINDOW_CLASS == "kitty_persistent" ]]; then
    kitty @ --to unix:/tmp/kittycmd new-window --new-tab man $MAN
else
    kitty man $MAN
fi
