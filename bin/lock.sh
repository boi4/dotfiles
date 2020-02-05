#!/usr/bin/env bash

temp_file="/tmp/screen.png"
width=1920
height=1080
blur_factor=5
lock_blur_factor=0
# https://ffmpeg.org/ffmpeg-filters.html
# avgblur: sizeX, planeBlur, sizeY
filter1="scale=$width:$height,avgblur=20:3:2,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2"
filter2="scale=$width:$height,boxblur=$blur_factor:$blur_factor,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2"
filter3="scale=$width:$height,gblur=2.8:6:,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2"
usedfilter="$filter1"

if [[ -z $WAYLAND_DISPLAY ]]; then
  icon="$HOME/.config/sway/lock.png"
	if [ "$1" == "screenshot" ]; then
	  ffmpeg -f x11grab \
	 	 -video_size "${width}x${height}" \
		 -y \
		 -i $DISPLAY \
		 -i $icon \
		 -filter_complex "boxblur=$blur_factor:$blur_factor,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,boxblur=$lock_blur_factor:$lock_blur_factor" \
		 -vframes 1 \
		 $temp_file
	else
	  ffmpeg -y \
	  	 -i "$HOME/.config/i3/wallpaper.png" \
		 -i $icon \
		 -filter_complex "scale=$width:$height,boxblur=$blur_factor:$blur_factor,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,boxblur=$lock_blur_factor:$lock_blur_factor" \
		 -vframes 1 \
		 $temp_file
	fi

	i3lock --no-unlock-indicator --ignore-empty-password --image=$temp_file -f
else
  icon="$HOME/.config/i3/lock.png"
	if [ "$1" == "screenshot" ]; then
		grim "$temp_file"
		ffmpeg -video_size "${width}x${height}" \
		       -y \
		       -i "$temp_file" \
		       -i $icon \
		       -filter_complex "$usedfilter" \
		       -vframes 1 \
		       $temp_file
	else
		ffmpeg -y \
		       -i "$HOME/.config/sway/wallpaper.png" \
		       -i $icon \
		       -filter_complex "$usedfilter" \
		       -vframes 1 \
		       $temp_file
	fi

	swaylock --no-unlock-indicator --ignore-empty-password --image=$temp_file -f
fi


rm $temp_file
