#!/bin/bash

# Launch applications in the background

# Wait briefly to ensure the applications have time to start

alacritty &
sleep 1

swaymsg 'workspace 2'
brave &
sleep 1

swaymsg 'workspace 3'
slack &
sleep 1

swaymsg 'workspace 1'

exit 0
