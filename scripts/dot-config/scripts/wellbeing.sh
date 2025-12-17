#!/usr/bin/env bash
notification_timeout=6000
APP_NAME="Wellbeing Timer"
notify() {
    notify-send "$1" "$2" -t "$notification_timeout" -a "$APP_NAME"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}
input=$(gum input --placeholder "Session duration in minutes [default is 90]")
duration=${input:- 90}
gum log -l info "Starting a $duration minutes session"
snore "$duration"m
notify "Time is up" "Time to rest your eyes and take a walk!"
