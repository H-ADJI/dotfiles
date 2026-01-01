#!/usr/bin/env bash

current=$(hyprctl -j getoption cursor:zoom_factor | jq -r '.float')

if awk "BEGIN{exit !($current > 1.0)}"; then
    hyprctl keyword cursor:zoom_factor 1.0
else
    hyprctl keyword cursor:zoom_factor 2
fi
