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
source ./lib/aur_helper.sh
source ./lib/packages.sh
source ./lib/secrets.sh
source ./lib/dotfiles.sh
source ./lib/projects.sh
source ./lib/extra_packages.sh
source ./lib/system_state.sh
