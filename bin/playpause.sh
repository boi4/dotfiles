#!/bin/bash

if [ $(playerctl status) == "Paused" ]
then
	playerctl play
else
	playerctl pause
fi
