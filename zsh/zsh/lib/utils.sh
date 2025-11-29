create_bootable_usb() {
    # Check if exactly two arguments are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: create_bootable_usb <path_to_iso> <device>"
        echo "Example: create_bootable_usb ubuntu_24.iso /dev/sda"
        echo "Use lsblk to list storage devices"
        return 1
    fi

    local iso_path="$1"
    local device="$2"

    # Verify the ISO file exists
    if [ ! -f "$iso_path" ]; then
        echo "Error: ISO file '$iso_path' does not exist."
        return 1
    fi

    # Verify the device exists
    if [ ! -e "$device" ]; then
        echo "Error: Device '$device' does not exist."
        return 1
    fi

    # Check if the device is mounted and unmount it
    if mount | grep -q "$device"; then
        echo "Unmounting $device..."
        sudo umount "$device"*
        if [ $? -ne 0 ]; then
            echo "Error: Failed to unmount $device."
            return 1
        fi
    fi

    # Write the ISO to the device
    echo "Writing $iso_path to $device..."
    sudo dd if="$iso_path" of="$device" bs=4M status=progress oflag=sync
    if [ $? -ne 0 ]; then
        echo "Error: Failed to write ISO to $device."
        return 1
    fi

    # Sync and eject the device
    echo "Syncing data..."
    sync
    echo "Ejecting $device..."
    sudo eject "$device"

    echo "Bootable USB created successfully!"
}
speaker_connect() {
    echo 'connect 10:94:97:36:C7:15' | bluetoothctl
}

copyp() {
    P="$(pwd)"
    if [ "$#" = 1 ]; then
        P="$(pwd)/$1"
    fi
    wl-copy "$P"
    return 0
}
copyf() {
    cat "$1" | wl-copy
    return 0
}
