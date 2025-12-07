#!/bin/sh
WALLPAPER="${HOME}/.config/assets/background"
pkill swaybg
swaybg -i "$WALLPAPER" -m fill &
