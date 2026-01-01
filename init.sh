#!/bin/bash

DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
gum log -l info "DOTFILES Setup For : $DISTRO"
# TODO: add fedora support
if [ "$DISTRO" = "arch" ]; then
    SETUPDIR="arch"
else
    SETUPDIR="ubuntu"
fi
if [ "$DISTRO" = "arch" ]; then
    sudo pacman -Syu --noconfirm
    toInstall=(
        "base-devel"
        "git"
        "vim"
        "go"
        "gum"
        "pv"
    )
    sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout "${toInstall[@]}"
else
    sudo apt update
    sudo apt upgrade -y
    toInstall=(
        "git"
        "vim"
        "nala"
    )
    sudo apt install -y "${toInstall[@]}"
fi
gum log -l info "Cloning DOTFILES"
[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles
cd dotfiles || exit 1

bash "$HOME/dotfiles/setup/$SETUPDIR/setup.sh"
