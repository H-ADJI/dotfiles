#!/usr/bin/env bash

CPU=$(top -l 1 -n 0 | grep -E "^CPU usage" | awk '{print int($3)}')

sketchybar --set $NAME label="${CPU}%"
