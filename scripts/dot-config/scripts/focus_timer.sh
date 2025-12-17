#!/usr/bin/env bash
DURATION=$(zenity --entry --title="Timer" --text="Enter duration (minutes)")
notification_timeout=8000
APP_NAME="Timer"
LOG_FILE="$HOME/.timer.log"

notify() {
    notify-send "$1" "$2" -t "$notification_timeout" -a "$APP_NAME"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}
notify "Timer Activated" "$DURATION minutes of focused work started !"
date +%s >"$LOG_FILE"

sleep "$((DURATION * 60))"

rm -f "$LOG_FILE"
notify "Time is up" "Time to rest your eyes and take a walk!"
