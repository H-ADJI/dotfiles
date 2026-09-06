#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

VOLUME=$INFO
MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

if [ -z "$VOLUME" ]; then
    VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
fi

if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
    ICON=󰝟
    ICON_COLOR=$GREY
elif [ "$VOLUME" -le 33 ]; then
    ICON=󰕿
    ICON_COLOR=$BLACK
elif [ "$VOLUME" -le 66 ]; then
    ICON=󰖀
    ICON_COLOR=$BLACK
else
    ICON=󰕾
    ICON_COLOR=$BLACK
fi

sketchybar --set $NAME icon=$ICON icon.color=$ICON_COLOR label="${VOLUME}%"
