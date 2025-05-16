#!/bin/bash

# Get root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if any parameters were provided
if [ $# -eq 0 ]; then
    echo "No sites provided to block. Usage: $0 site1 site2 ..."
    exit 1
fi

# Store parameters in BLOCKED_SITES array
BLOCKED_SITES=("$@")

# Loop through blocked sites and add them to hosts file
for site in "${BLOCKED_SITES[@]}"; do
    # Skip empty parameters
    [[ -z "$site" ]] && continue

    if grep -q "$site" /etc/hosts; then
        echo "$site is already blocked."
    else
        echo "Blocking $site..."
        echo "127.0.0.1 $site" >>/etc/hosts
    fi
done

echo "All sites have been blocked."
