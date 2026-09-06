#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

SSID=$(ipconfig getsummary en0 2>/dev/null | grep -o "SSID : .*" | sed 's/^SSID : //' | tail -n 1)

if [ -n "$SSID" ]; then
    ICON=󰤨
    ICON_COLOR=$BLUE
else
    ICON=󰤭
    ICON_COLOR=$GREY
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR label="$SSID"
