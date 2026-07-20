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
curl -fsSL "https://h-adji.github.io/dotfiles/$CURRENT_OS/setup/main.sh" | bash
