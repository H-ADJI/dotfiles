#!/bin/sh
# Set default duration in seconds (e.g., 20 minutes = 1200 seconds)
DURATION=2700
notification_timeout=8000
APP_NAME="Timer"
STEPS=30
LOG_FILE="$HOME/.timer.log"

hours=$((DURATION / 3600))
minutes=$(((DURATION % 3600) / 60)) # Get remaining minutes

# Format as HH:MM
hours=$(printf "%02d" $hours)
minutes=$(printf "%02d" $minutes)

notify() {
    notify-send "$1" "$2" -t "$notification_timeout" -a "$APP_NAME"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}
notify "Timer Activated" "Your ${hours}h$minutes of focused work has started !"
date +%s >"$LOG_FILE"

while [ $DURATION -ge 0 ]; do
    sleep $STEPS
    DURATION=$((DURATION - STEPS))
done

rm -f "$LOG_FILE"
notify "Time is up" "Time to rest your eyes and take a walk!"
