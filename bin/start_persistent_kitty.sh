#!/bin/sh

kitty --class kitty_persistent -o allow_remote_control=yes --listen-on unix:/tmp/kittycmd
