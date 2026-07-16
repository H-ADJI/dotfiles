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
[ ! -d "dotfiles" ] && git clone --branch migration/multi_os_setup https://github.com/H-ADJI/dotfiles

cat >>~/.bashrc <<'EOF'
SETUP_DIR="dotfiles/arch/setup/lib"
launc_setup() {
    bash "$SETUP_DIR/aur_helper.sh"
    bash "$SETUP_DIR/packages.sh"
    bash "$SETUP_DIR/dotfiles.sh"
    bash "$SETUP_DIR/extra_packages.sh"
    bash "$SETUP_DIR/system_state.sh"
}
export PATH=$PATH:~/$SETUP_DIR
EOF
