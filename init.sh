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
curl -fsSL "https://hh9dj.github.io/PDE/$CURRENT_OS/main.sh" | bash
