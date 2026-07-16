#!/bin/bash

echo_os() {
    [[ "$(uname)" == "Darwin" ]] && {
        echo macos
        return
    }

    source /etc/os-release
    echo "$ID"
}

# TODO: Bypass git dependency by calling os specific init script from url instead of from local repo
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git not found."
    echo "Please install git and run this script again."
    exit 1
fi

[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles

CURRENT_OS="$(echo_os)"
curl -fsSL "https://raw.githubusercontent.com/H-ADJI/dotfiles/migration/multi_os_setup/$CURRENT_OS/setup/main.sh" | bash
