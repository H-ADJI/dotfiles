#!/usr/bin/env bash

# Define the zoom step and boundaries
STEP=0.5
MIN_ZOOM=1.0
MAX_ZOOM=5.0

# Get the current zoom factor
current_zoom=$(hyprctl -j getoption cursor:zoom_factor | jq -r '.float')

# Determine new zoom level based on argument
if [[ "$1" == "in" ]]; then
    new_zoom=$(awk "BEGIN {print $current_zoom + $STEP}")
elif [[ "$1" == "out" ]]; then
    new_zoom=$(awk "BEGIN {print $current_zoom - $STEP}")
else
    # Default to toggle if no/wrong argument
    if awk "BEGIN{exit !($current_zoom > 1.0)}"; then
        new_zoom=1.0
    else
        new_zoom=2.0
    fi
fi

# Clamp the zoom level within boundaries
if awk "BEGIN{exit !($new_zoom < $MIN_ZOOM)}"; then
    new_zoom=$MIN_ZOOM
fi

if awk "BEGIN{exit !($new_zoom > $MAX_ZOOM)}"; then
    new_zoom=$MAX_ZOOM
fi

# Apply the new zoom factor
hyprctl keyword cursor:zoom_factor "$new_zoom"
