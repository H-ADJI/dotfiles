#!/usr/bin/env bash
# Create the directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
timeout=3000
# Generate a filename based on the current date and time
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
APP_NAME="Sway Screenshot"
case $1 in
    region)
        XY="$(slurp -w 2)"
        if [ $? -eq 1 ]; then
            exit 1
        fi
        grim -g "$XY" - | tee "$FILENAME" | wl-copy
        ;;
    display)
        # grim - | tee "$FILENAME" | wl-copy
        output_id=$(hyprctl activeworkspace -j | jq -r '.monitor')
        grim -o "$output_id" - | tee "$FILENAME" | wl-copy
        ;;
esac

notify-send "Screenshot taken" "Saved to $FILENAME" -t "$timeout" -i "$FILENAME" -a "$APP_NAME"
paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &
swappy -f "$FILENAME"
