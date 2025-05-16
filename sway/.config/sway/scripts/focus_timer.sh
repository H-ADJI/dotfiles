#!/bin/sh
# Set default duration in seconds (e.g., 20 minutes = 1200 seconds)
DURATION=5400
timeout=8000
APP_NAME="Timer"
STEPS=1
BREAK=180

hours=$((DURATION / 3600))
minutes=$(((DURATION % 3600) / 60)) # Get remaining minutes

# Format as HH:MM
hours=$(printf "%02d" $hours)
minutes=$(printf "%02d" $minutes)

notify() {
    notify-send "$1" "$2" -t "$timeout" -a "$APP_NAME"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}
notify "Timer Activated" "Your ${hours}h$minutes of focused work has started !"

while [ $DURATION -ge 0 ]; do
    if [ "$DURATION" -eq $((DURATION / 3)) ] || [ "$DURATION" -eq $((2 * DURATION / 3)) ]; then
        notify "Short Break" "Take a quick 1-minute break ✨"
        sleep $BREAK
        notify "Short Break" "Done"
    fi
    sleep $STEPS
    DURATION=$((DURATION - STEPS))
done

notify "Time is up" "Time to rest your eyes and take a walk!"
