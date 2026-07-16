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

# TODO: early return for manual testing
# TODO: activate prompts using args
gum confirm "install AUR helper"
bash "$SETUP_DIR/aur_helper.sh"

gum confirm "install packages"
bash "$SETUP_DIR/packages.sh"

gum confirm "Setup projects"
bash "$SETUP_DIR/projects.sh"

gum confirm "Decrypt secrets"
bash "$SETUP_DIR/secrets.sh"

gum confirm "Link dotfiles"
bash "$SETUP_DIR/dotfiles.sh"

gum confirm "install extra packages"
bash "$SETUP_DIR/extra_packages.sh"

gum confirm "Set system state"
bash "$SETUP_DIR/system_state.sh"
