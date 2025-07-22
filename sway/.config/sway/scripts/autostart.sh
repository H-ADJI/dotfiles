#!/bin/bash
# Launch applications in the background
alacritty &
sleep 2
swaymsg 'workspace 2'
brave &
echo 'connect 10:94:97:36:C7:15' | bluetoothctl

exit 0
