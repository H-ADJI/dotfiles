#!/bin/bash
# This script lists Genymotion devices using the JSON output from gmtool,
# presents a fuzzel menu to select a device, and launches the selected device.

# Get the list of device names from gmtool using JSON output.
devices=$(gmtool admin list --format json | jq -r '.instances[].name')

# Check if any devices were found.
if [ -z "$devices" ]; then
    notify-send "Genymotion Launcher" "No Genymotion devices found."
    exit 1
fi

# Present the list using fuzzel for interactive selection.
selected_device=$(echo "$devices" | fuzzel --dmenu --prompt="Select Device ❯ ")

# If a device was selected, launch it with Genymotion Player.
if [ -n "$selected_device" ]; then
    /opt/genymotion/player --vm-name "$selected_device" &
fi
sleep 10
adb shell setprop persist.sys.root_access 3 && adb root
