#!/bin/sh
WALLPAPER="${HOME}/.config/assets/background"
killall -q swaybg
swaybg -i "$WALLPAPER" -m fill &
