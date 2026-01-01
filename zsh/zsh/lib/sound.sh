choose_output() {
    local selection device desc
    selection=$(
        pactl list short sinks | awk '{print $2}' | while IFS= read -r id; do
            desc=$(pactl list sinks | awk -v dev="$id" '
        $0 ~ "Name: "dev {found=1}
        found && /Description:/ {
          sub(/^[ \t]*/,""); sub(/^Description:[ \t]*/,""); print; exit
            }')
            [ -z "$desc" ] && desc="$id"
            printf "%s\t%s\n" "$id" "$desc"
        done | fzf --with-nth=2 --delimiter=$'\t' --prompt="Output: " --height=20 --reverse
    )

    [ -z "$selection" ] && return

    device=${selection%%$'\t'*}
    desc=${selection#*$'\t'}

    echo "🔊 Output set to: $desc"
    pactl set-default-sink "$device"

    # move existing playback streams
    for id in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$id" "$device" 2>/dev/null || true
    done
}

choose_input() {
    local selection device desc
    selection=$(
        pactl list short sources | awk '!/\.monitor/ {print $2}' | while IFS= read -r id; do
            desc=$(pactl list sources | awk -v dev="$id" '
        $0 ~ "Name: "dev {found=1}
        found && /Description:/ {
          sub(/^[ \t]*/,""); sub(/^Description:[ \t]*/,""); print; exit
            }')
            [ -z "$desc" ] && desc="$id"
            printf "%s\t%s\n" "$id" "$desc"
        done | fzf --with-nth=2 --delimiter=$'\t' --prompt="Input: " --height=20 --reverse
    )

    [ -z "$selection" ] && return

    device=${selection%%$'\t'*}
    desc=${selection#*$'\t'}

    echo "🎤 Input set to: $desc"
    pactl set-default-source "$device"

    # move existing recording streams
    for id in $(pactl list short source-outputs | awk '{print $1}'); do
        pactl move-source-output "$id" "$device" 2>/dev/null || true
    done
}

speaker_connect() {
    echo 'connect 10:94:97:36:C7:15' | bluetoothctl
}
