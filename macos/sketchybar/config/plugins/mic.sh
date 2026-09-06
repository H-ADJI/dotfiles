#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)

if [ -z "$VOLUME" ] || [ "$VOLUME" = "0" ]; then
    ICON=󰍭
    ICON_COLOR=$GREY
else
    ICON=󰍬
    ICON_COLOR=$MAGENTA
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR label="${VOLUME}%"
