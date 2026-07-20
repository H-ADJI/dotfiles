#!/bin/env bash
set -euo pipefail
BRANCH="${1:-migration/multi_os_setup}"
SETUP_DIR="$HOME/dotfiles/arch/setup/lib"

run_step() {
    gum log -l info "[RUN] $1"
    bash "$SETUP_DIR/$1"
}

sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout \
    base-devel git vim go gum

[ ! -d "$HOME/dotfiles" ] && git clone --branch "$BRANCH" https://github.com/H-ADJI/dotfiles "$HOME/dotfiles"

cat >>~/.bashrc <<'SETUP_EOF'
SETUP_DIR="$HOME/dotfiles/arch/setup/lib"
launch_setup() {
    for step in aur_helper.sh packages.sh dotfiles.sh extra_packages.sh system_state.sh; do
        bash "$SETUP_DIR/$step"
    done
}
SETUP_EOF

run_step aur_helper.sh
run_step packages.sh
run_step dotfiles.sh
run_step extra_packages.sh
run_step system_state.sh
