# Function to check remaining time of the timer
check_timer() {
    LOG_FILE="$HOME/.timer.log"
    DURATION=3600 # Must match the DURATION in timer.sh

    if [ ! -f "$LOG_FILE" ]; then
        echo "No active timer found."
        return 1
    fi

    start_time=$(cat "$LOG_FILE")
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    remaining=$((DURATION - elapsed))

    if [ $remaining -le 0 ]; then
        echo "Timer has already ended."
        rm -f "$LOG_FILE"
        return 0
    fi

    hours_remaining=$((remaining / 3600))
    minutes_remaining=$(((remaining % 3600) / 60))
    seconds_remaining=$((remaining % 60))

    printf "Time remaining: %02dh:%02dm:%02ds\n" $hours_remaining $minutes_remaining $seconds_remaining
}
