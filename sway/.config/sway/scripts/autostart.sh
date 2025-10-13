#!/bin/bash
alacritty &
sleep 2
swaymsg 'workspace 2'
brave --ozone-platform=wayland --ozone-platform-hint=wayland &
sleep 2
swaymsg 'workspace 3'
slack &
echo 'connect 10:94:97:36:C7:15' | bluetoothctl
sleep 2
swaymsg 'workspace 2'

exit 0
