#!/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES_DIR:-$HOME/dotfiles}"

if [ ! -d "$DOTFILES/arch" ]; then
    gum log -l error "dotfiles repo not found at $DOTFILES"
    exit 1
fi

gum log -l info "[START] Installing extra pacman packages"
sudo pacman -S --noconfirm --needed --disable-download-timeout \
    - <"$DOTFILES/arch/setup/packages/requirements-pacman-extras.txt"
gum log -l info "[DONE] Extra pacman packages"

gum log -l info "[START] Installing extra AUR packages"
yay -S --noconfirm --needed --disable-download-timeout \
    - <"$DOTFILES/arch/setup/packages/requirements-aur-extras.txt"
gum log -l info "[DONE] Extra AUR packages"

gum log -l info "All extra packages installed."
gum log -l info "Override dotfiles path: DOTFILES_DIR=/path/to/dotfiles bash install-extras.sh"
