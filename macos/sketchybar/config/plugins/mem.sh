#!/usr/bin/env bash

TOTAL=$(sysctl -n hw.memsize)
FREE=$(memory_pressure -Q | grep -Eo "[0-9]+" | tail -1)

USED=$(awk -v t="$TOTAL" -v f="$FREE" 'BEGIN { printf "%.1f", t * (100 - f) / 100 / 1073741824 }')

sketchybar --set $NAME label="${USED}GB"
