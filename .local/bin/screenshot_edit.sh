#!/usr/bin/env bash
if [ -n "$WAYLAND_DISPLAY" ]; then
  fname="$HOME/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%h-%m-%s-%N).png"
  grim -g "$(slurp)" "$fname"
  pinta "$fname"
elif [ -n "$DISPLAY" ]; then
  fname="$HOME/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%h-%m-%s-%N).png"
  scrot "$fname" -s -e 'pinta $f'
  xclip -selection clipboard -target image/png -i < "$fname"
fi
