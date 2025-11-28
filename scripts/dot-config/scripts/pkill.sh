#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
FUZZEL_OPTS=(--dmenu --lines=12 --width=80 --prompt="💀 Kill program: ")
ICON="utilities-terminal"

# === Collect running processes ===
# Use pgrep -a to show PID + full command, group by executable basename
procs=$(
    pgrep -a -u "$USER" 2>/dev/null | awk '
        {
            full = substr($0, index($0,$2))   # full command line
            base = $2
            sub(".*/", "", base)              # strip path → just executable name
            count[base]++
            line[base] = full
        }
        END {
            for (c in count)
                printf "%-25s %s\n", c " (" count[c] ")", line[c]
    }' |
    sort -k1,1
)

# === Exit early if no processes ===
[ -z "$procs" ] && {
    notify-send -u low "💀 Process Killer" "No processes found."
    exit 0
}

# === Choose a process ===
selection=$(echo "$procs" | fuzzel "${FUZZEL_OPTS[@]}")
[ -z "$selection" ] && exit 0

# Extract program name (strip parentheses and count)
cmd=$(awk '{print $1}' <<<"$selection" | sed 's/(.*)//;s/[[:space:]]*$//')

# Extract count (optional, for prompt)
count=$(awk '{print $1}' <<<"$selection" | grep -oP '\(\K[0-9]+(?=\))' || echo 0)

# === Verify actual running count (full command line match) ===
actual_count=$(pgrep -f -c "$cmd" || echo 0)
if [[ "$actual_count" -eq 0 ]]; then
    notify-send -u critical "💀 Process Killer" "No running processes found for <b>$cmd</b>."
    exit 1
fi

# === Confirm before killing ===
confirm=$(echo -e "Yes\nNo" | fuzzel --dmenu --width=40 --prompt="Kill $count '$cmd' process(es)? ")
[[ "$confirm" != "Yes" ]] && exit 0

# === Kill processes ===
if pkill -9 -f "$cmd" 2>/dev/null; then
    notify-send -a "Process Killer" -i "$ICON" -u normal \
        "💀 Killed program" "<b>$cmd</b> — $count process(es) terminated."
else
    notify-send -u critical "💀 Process Killer" "❌ Failed to kill <b>$cmd</b>."
fi
