#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=0xff2ea043
else
    sketchybar --set $NAME label.color=0xffffffff
fi
