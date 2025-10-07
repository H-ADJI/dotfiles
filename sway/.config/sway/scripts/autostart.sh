#!/bin/bash
alacritty &
sleep 2
swaymsg 'workspace 2'
firefox &
sleep 2
swaymsg 'workspace 3'
slack &
echo 'connect 10:94:97:36:C7:15' | bluetoothctl
sleep 2
swaymsg 'workspace 2'

exit 0
