#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=$BLUE label.font="JetBrainsMono Nerd Font:Black:18.0"
else
    sketchybar --set $NAME label.color=$BLACK label.font="JetBrainsMono Nerd Font:Bold:18.0"
fi
