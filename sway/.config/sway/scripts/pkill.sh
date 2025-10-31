#!/usr/bin/env bash
set -euo pipefail

# --- Collect process names ---
# pgrep -a shows PID + command; we extract command name safely.
# Use awk to group by program name, count instances, and format cleanly.

procs=$(
    pgrep -a -u "$USER" 2>/dev/null | awk '
        {
            full = substr($0, index($0,$2))   # full command line
            base = $2
            sub(".*/", "", base)
            count[base]++
            line[base] = full
        }
        END {
            for (c in count)
                printf "%-25s\t%s\t(%s instances)\n", c, line[c], count[c]
    }' |
    sort -k3 -nr
)

[ -z "$procs" ] && {
    notify-send -u low "💀 Process Killer" "No processes found."
    exit 0
}

# --- Choose process ---
selection=$(echo "$procs" | fuzzel --prompt="💀 Kill program: " --dmenu --lines=10 --width=80)
[ -z "$selection" ] && exit 0

cmd=$(awk '{print $1}' <<<"$selection")

# --- Count instances ---
count=$(pgrep -c "$cmd" || echo 0)
if [[ "$count" -eq 0 ]]; then
    notify-send -u critical "💀 Process Killer" "No running processes found for <b>$cmd</b>."
    exit 1
fi

# --- Confirm ---
confirm=$(echo -e "Yes\nNo" | fuzzel --prompt="Kill $count '$cmd' process(es)? " --dmenu)
[[ "$confirm" != "Yes" ]] && exit 0

# --- Kill ---
if pkill -9 "$cmd" 2>/dev/null; then
    notify-send -a "Process Killer" -i utilities-terminal -u normal \
        "💀 Killed program" "<b>$cmd</b> — $count process(es) terminated."
else
    notify-send -u critical "💀 Process Killer" "❌ Failed to kill <b>$cmd</b>."
fi
