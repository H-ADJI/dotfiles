#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

STATE=$(blueutil -p)

if [ "$STATE" = "1" ]; then
    ICON=󰂯
    ICON_COLOR=$BLUE
else
    ICON=󰂲
    ICON_COLOR=$GREY
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR label=""
