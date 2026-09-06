#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

IP=$(ipconfig getifaddr en0)

if [ -n "$IP" ]; then
    ICON=󰤨
    ICON_COLOR=$BLUE
else
    ICON=󰤭
    ICON_COLOR=$RED
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR
