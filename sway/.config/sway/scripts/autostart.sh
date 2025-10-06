#!/bin/bash
alacritty &
sleep 2
swaymsg 'workspace 2'
firefox &
sleep 2
swaymsg 'workspace 3'
slack &
spotify &
sleep 3
swaymsg 'workspace 2'
echo 'connect 10:94:97:36:C7:15' | bluetoothctl

exit 0
