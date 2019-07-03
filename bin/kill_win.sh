#!/bin/sh

ACTIVE_WINDOW_ID=$(xprop -root | awk '/NET_ACTIVE_WINDOW/ { print $5; exit}')
ACTIVE_WINDOW_CLASS=$(xprop -id $ACTIVE_WINDOW_ID | awk -F\" '/WM_CLASS/ {print $2; exit}')
[[ $ACTIVE_WINDOW_CLASS != "kitty_persistent" ]] && i3-msg kill
