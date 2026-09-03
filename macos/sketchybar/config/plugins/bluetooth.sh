#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

STATE=$(blueutil -p)
CONN=$(blueutil --connected | grep -c "address")

if [ "$STATE" = "1" ]; then
    ICON=󰂯
    ICON_COLOR=$BLUE
else
    ICON=󰂲
    ICON_COLOR=$GREY
fi

if [ "$CONN" -gt 0 ]; then
    LABEL="$CONN"
else
    LABEL=""
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR label="$LABEL"
