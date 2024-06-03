#!/bin/bash
rembg i "$1" "$3/bgremoved-${2}"

if [ $? -eq 0 ]; then
	notify-send "Operation completed successfully"
else
	notify-send "Operation wasn't successful. An Error ocurred"
fi
