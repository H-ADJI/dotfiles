#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.color=0xff3584e4 label.color=0xffffffff
else
    sketchybar --set $NAME background.color=0xccfafafa label.color=0xff2e3436
fi