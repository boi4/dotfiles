#!/usr/bin/env bash


mkdir -p "$HOME/Pictures/screenshots"

opt="$1";
case "$opt" in
    "full" )
        grim $HOME/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%h-%m-%s-%N).png;;
    "select" )
        grim -g "$(slurp)" $HOME/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%h-%m-%s-%N).png;;
esac
