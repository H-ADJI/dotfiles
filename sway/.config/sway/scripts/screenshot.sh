#!/bin/sh
# Create the directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
timeout=3000
# Generate a filename based on the current date and time
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
APP_NAME="Sway Screenshot"

case $1 in
    window)
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" - |
        tee "$FILENAME"
        ;;
    region)
        grim -g "$(slurp)" - | tee "$FILENAME" | wl-copy
        ;;
    display)
        # grim - | tee "$FILENAME" | wl-copy
        output_id=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
        grim -o "$output_id" - | tee "$FILENAME" | wl-copy
        ;;
esac
notify-send "Screenshot taken" "Saved to $FILENAME" -t "$timeout" -i "$FILENAME" -a "$APP_NAME"
paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &
swappy -f "$FILENAME"
