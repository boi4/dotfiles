#!/bin/bash
# Jan Fecht
# 2.12.18

option="$1"

case $option in
	"reboot")
		if [ "$(printf 'yes\nno\n' | dmenu -i -p 'reboot')" == "yes" ]
		then
			wmctrl -c "Mozilla Firefox"
			sleep 1
			reboot
		fi;;
	"shutdown")
		if [ "$(printf 'yes\nno\n' | dmenu -i -p 'shutdown')" == "yes" ]
		then
			wmctrl -c "Mozilla Firefox"
			sleep 1
			shutdown -h now
		fi;;
esac
