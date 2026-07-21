#!/usr/bin/env bash
set -euo pipefail

load_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        return
    fi

    if [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        return
    fi
}

install_homebrew() {
    load_homebrew
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_homebrew
}

install_nix() {
    if command -v nix >/dev/null 2>&1; then
        return
    fi

    echo "Installing Lix."
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install

    if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # shellcheck disable=SC1091
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
}

install_first_tools() {
    brew install --cask google-chrome
    brew install --cask ghostty
    brew install anomalyco/tap/opencode
}

install_nix
install_homebrew
install_first_tools

echo "macOS bootstrap done. Open Ghostty, clone dotfiles if needed, then continue nix-darwin setup."
