#!/bin/env bash

sudo pacman -Syu --noconfirm
toInstall=(
    "base-devel"
    "git"
    "vim"
    "go"
    "gum"
)
sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout "${toInstall[@]}"

# TODO: dynamic branch from args
[ ! -d "dotfiles" ] && git clone --branch migration/multi_os_setup https://github.com/H-ADJI/dotfiles

SETUP_DIR="$HOME/dotfiles/arch/setup/lib"

# TODO: early return for manual testing
source $SETUP_DIR/aur_helper.sh

source "$SETUP_DIR/packages.sh"

source "$SETUP_DIR/secrets.sh"

source "$SETUP_DIR/dotfiles.sh"

source "$SETUP_DIR/projects.sh"

source "$SETUP_DIR/extra_packages.sh"

source "$SETUP_DIR/system_state.sh"
