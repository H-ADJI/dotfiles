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

SETUP_DIR="dotfiles/arch/setup/lib"
bash "$SETUP_DIR/aur_helper.sh"
bash "$SETUP_DIR/packages.sh"
bash "$SETUP_DIR/projects.sh"
bash "$SETUP_DIR/secrets.sh"
bash "$SETUP_DIR/dotfiles.sh"
bash "$SETUP_DIR/extra_packages.sh"
bash "$SETUP_DIR/system_state.sh"
