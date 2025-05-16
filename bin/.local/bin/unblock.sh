#!/bin/bash

# Get root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if any parameters were provided
if [ $# -eq 0 ]; then
    echo "No sites provided to unblock. Usage: $0 site1 site2 ..."
    exit 1
fi

# Store parameters in UNBLOCKED_SITES array
UNBLOCKED_SITES=("$@")

# Loop through unblocked sites and remove them from hosts file
for site in "${UNBLOCKED_SITES[@]}"; do
    # Skip empty parameters
    [[ -z "$site" ]] && continue

    if grep -q "$site" /etc/hosts; then
        echo "Unblocking $site..."
        sed -i "/$site/d" /etc/hosts
    else
        echo "$site is already unblocked."
    fi
done

echo "All sites have been unblocked."
