#!/bin/sh
DURATION=5400
notification_timeout=8000
APP_NAME="Timer"
STEPS=30
LOG_FILE="$HOME/.timer.log"

notify() {
    notify-send "$1" "$2" -t "$notification_timeout" -a "$APP_NAME"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}
notify "Timer Activated" "90 minutes of focused work started !"
date +%s >"$LOG_FILE"

while [ $DURATION -ge 0 ]; do
    sleep $STEPS
    DURATION=$((DURATION - STEPS))
done

rm -f "$LOG_FILE"
notify "Time is up" "Time to rest your eyes and take a walk!"
