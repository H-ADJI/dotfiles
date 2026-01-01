#!/bin/bash
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
cd dotfiles || exit 1
sudo --validate
bash "$HOME/dotfiles/setup/setup.sh"
