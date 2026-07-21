#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || {
    echo "macOS required." >&2
    exit 1
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOST="${HOST:-$(scutil --get LocalHostName)}"

if ! command -v nix >/dev/null 2>&1; then
    echo "Installing Lix. Restart terminal, then rerun this script."
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install
    exit 0
fi

FLAKE="$DOTFILES/macos#$HOST"
if command -v darwin-rebuild >/dev/null 2>&1; then
    exec sudo darwin-rebuild switch --flake "$FLAKE"
fi

exec sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$FLAKE"
