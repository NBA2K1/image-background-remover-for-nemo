#!/bin/bash
rembg i "$1" "$3/bgremoved-${2}"

if [ $? -eq 0 ]; then
	notify-send "SUCCESS"
else
	notify-send "ERROR"
fi
