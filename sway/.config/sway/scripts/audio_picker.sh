#!/usr/bin/env bash
set -euo pipefail

# --- Usage check ---
if [[ $# -ne 1 ]] || [[ "$1" != "sink" && "$1" != "source" ]]; then
    echo "Usage: $0 <sink|source>"
    exit 1
fi

type="$1"
icon=""
prompt=""
move_cmd=""
list_cmd=""
list_cmd_full=""
desc_type=""

# --- Type-specific configuration ---
if [[ "$type" == "sink" ]]; then
    icon="🔊"
    prompt="Output"
    move_cmd="pactl move-sink-input"
    list_cmd="pactl list short sinks"
    list_cmd_full="pactl list sinks"
    desc_type="sink"
else
    icon="🎤"
    prompt="Input"
    move_cmd="pactl move-source-output"
    list_cmd="pactl list short sources | awk '!/\.monitor/'"
    list_cmd_full="pactl list sources"
    desc_type="source"
fi

# --- Build device list ---
devices=$(
    eval "$list_cmd" | awk '{print $2}' | while IFS= read -r id; do
        desc=$(eval "$list_cmd_full" | awk -v dev="$id" '
            $0 ~ "Name: "dev {found=1}
            found && /Description:/ {
                sub(/^[ \t]*/,""); sub(/^Description:[ \t]*/,""); print; exit
        }')
        [ -z "$desc" ] && desc="$id"
        printf "%s\t%s\n" "$id" "$desc"
    done
)

# --- Fuzzel menu ---
selection=$(echo "$devices" | awk -F'\t' '{print $2}' | fuzzel --prompt="$icon $prompt: " --dmenu)
[ -z "$selection" ] && exit 0

# --- Find device name ---
device=$(echo "$devices" | awk -F'\t' -v desc="$selection" '$2 == desc {print $1; exit}')
[ -z "$device" ] && {
    notify-send -u critical "$icon Audio $prompt" "❌ No matching device found for <b>$selection</b>"
    exit 1
}

# --- Set default device ---
pactl set-default-"$type" "$device"

# --- Move active streams ---
if [[ "$type" == "sink" ]]; then
    pactl list short sink-inputs | awk '{print $1}' | while read -r id; do
        $move_cmd "$id" "$device" 2>/dev/null || true
    done
else
    pactl list short source-outputs | awk '{print $1}' | while read -r id; do
        $move_cmd "$id" "$device" 2>/dev/null || true
    done
fi

# --- Notify ---
notify-send \
    -a "Audio Switcher" \
    -i audio-input-microphone \
    -h string:x-canonical-private-synchronous:audio-switch \
    -u normal \
    "$icon ${prompt} changed" \
    "<b>Now using:</b> $selection"
