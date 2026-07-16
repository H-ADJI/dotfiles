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
[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles

bash ./lib/aur_helper.sh
bash ./lib/packages.sh
bash ./lib/projects.sh
bash ./lib/secrets.sh
bash ./lib/dotfiles.sh
bash ./lib/extra_packages.sh
bash ./lib/system_state.sh
