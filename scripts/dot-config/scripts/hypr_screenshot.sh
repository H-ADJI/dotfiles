#!/usr/bin/env bash
# Create the directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
timeout=3000
# Generate a filename based on the current date and time
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
APP_NAME="Sway Screenshot"
grim -g "$(slurp -w 2)" - | tee "$FILENAME" | wl-copy
notify-send "Screenshot taken" "Saved to $FILENAME" -t "$timeout" -i "$FILENAME" -a "$APP_NAME"
paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &
swappy -f "$FILENAME"
