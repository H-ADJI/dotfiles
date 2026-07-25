#!/usr/bin/env bash
set -euo pipefail

FLAKE="github:hh9dj/PDE?dir=macos"
HOST="${HOST:-$(scutil --get LocalHostName 2>/dev/null || echo macbook)}"

if ! command -v nix >/dev/null 2>&1; then
    echo "=> Installing Lix. Restart terminal, then rerun this script."
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install
    exit 0
fi

echo "=> Rebuilding: $FLAKE#$HOST"
if command -v darwin-rebuild >/dev/null 2>&1; then
    exec sudo darwin-rebuild switch --flake "$FLAKE#$HOST"
fi
exec sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$FLAKE#$HOST"
