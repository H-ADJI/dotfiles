#!/usr/bin/env bash
XY="$(slurp)"
if [ $? -eq 0 ]; then
    TMP=$(mktemp)
    grim -g "$XY" - >"$TMP"
    imv -u nearest_neighbour "$TMP"
    rm "$TMP"
fi
