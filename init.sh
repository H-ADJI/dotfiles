#!/bin/bash

echo_os() {
    [[ "$(uname)" == "Darwin" ]] && {
        echo macos
        return
    }

    source /etc/os-release
    echo "$ID"
}


CURRENT_OS="$(echo_os)"
curl -fsSL "https://raw.githubusercontent.com/H-ADJI/dotfiles/migration/multi_os_setup/$CURRENT_OS/setup/main.sh" | bash
