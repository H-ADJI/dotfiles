#!/bin/bash
# Launch applications in the background
alacritty &
sleep 2
swaymsg 'workspace 2'
brave &

exit 0
