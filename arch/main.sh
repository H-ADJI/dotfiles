#!/bin/env bash
set -euo pipefail
trap 'echo "[FAIL] main.sh line $LINENO" >&2' ERR

log_start() { gum log --message.foreground "#d20f39" "→ $*"; }
log_done() { gum log --message.foreground "#40a02b" "✓ $*"; }
log_skip() { gum log --message.foreground "#df8e1d" "… $*"; }
log_error() { gum log --message.foreground "#d20f39" "✗ $*"; }

BRANCH="${1:-master}"
DOTFILES="$HOME/dotfiles"

bootstrap_system() {
    sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout \
        base-devel git vim go gum go-yq &>/dev/null
    if [ ! -d "$DOTFILES" ]; then
        git clone --branch "$BRANCH" https://github.com/hh9dj/dotfiles "$DOTFILES"
    fi
}

packages() {
    yq -r ".$1.$2 // [] | .[] | select(. != null)" "$DOTFILES/arch/packages.yml"
}

install_aur_helper() {
    if command -v yay &>/dev/null; then
        log_skip "yay already installed, skipping"
        return
    fi
    local YAY_DIR="/tmp/yay"
    git clone --depth 1 https://aur.archlinux.org/yay.git "$YAY_DIR"
    (cd "$YAY_DIR" && makepkg -si --noconfirm)
    rm -rf "$YAY_DIR"
}

install_packages() {
    local package_file
    package_file=$(mktemp)

    packages pacman base >"$package_file"
    if [ -s "$package_file" ]; then
        log_start "installing base pacman packages"
        sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - <"$package_file" &>/dev/null
        log_done "base pacman packages installed"
    else
        log_skip "no base pacman packages"
    fi

    packages aur base >"$package_file"
    if [ -s "$package_file" ]; then
        log_start "installing base AUR packages"
        yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - <"$package_file" &>/dev/null
        log_done "base AUR packages installed"
    else
        log_skip "no base AUR packages"
    fi

    if systemd-detect-virt -c &>/dev/null; then
        log_skip "container detected, skipping extra packages"
        rm -f "$package_file"
        return
    fi

    packages pacman extra >"$package_file"
    if [ -s "$package_file" ]; then
        log_start "installing extra pacman packages"
        sudo pacman -S --noconfirm --needed --disable-download-timeout - <"$package_file"
        log_done "extra pacman packages installed"
    else
        log_skip "no extra pacman packages"
    fi

    packages aur extra >"$package_file"
    if [ -s "$package_file" ]; then
        log_start "installing extra AUR packages"
        yay -S --noconfirm --needed --disable-download-timeout - <"$package_file"
        log_done "extra AUR packages installed"
    else
        log_skip "no extra AUR packages"
    fi

    rm -f "$package_file"
}

setup_dotfiles() {
    log_start "switching remote to SSH"
    git -C "$DOTFILES" remote set-url origin git@github.com:hh9dj/dotfiles.git 2>/dev/null ||
    git -C "$DOTFILES" remote add origin git@github.com:hh9dj/dotfiles.git
    log_done "remote switched to SSH"

    log_start "stowing dotfiles"
    rm -rf "$HOME/.config/hypr"
    for dir in "$DOTFILES"/arch/*/; do
        stow --dotfiles --adopt -d "$DOTFILES/arch" -t "$HOME" "$(basename "$dir")" 2>/dev/null
    done
    log_done "stowing dotfiles"

    log_start "cloning projects"
    local projects_dir="$HOME/projects"
    mkdir -p "$projects_dir"
    local -a projects=(ccraft homelab neurogenesis secondBrain zmk-config learn_nix)
    for project in "${projects[@]}"; do
        [ ! -d "$projects_dir/$project" ] && git clone -q --depth 1 "git@github.com:hh9dj/$project.git" "$projects_dir/$project"
    done
    log_done "projects cloned"
}

install_devtools() {
    log_start "installing mise tools"
    mise i --locked -q
    log_done "mise tools installed"

    log_start "installing nvim plugins"
    nvim --headless -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa' &>/dev/null
    log_done "nvim plugins installed"

    log_start "installing TPM plugins"
    local TPM_DIR="$HOME/.tmux/plugins/tpm"
    [ ! -d "$TPM_DIR" ] && git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    bash ~/.tmux/plugins/tpm/bin/install_plugins &>/dev/null
    log_done "TPM plugins installed"
}

setup_system_state() {
    if systemd-detect-virt -c &>/dev/null; then
        log_skip "container detected, skipping"
        return
    fi

    sudo usermod -aG docker "$USER"
    sudo timedatectl set-timezone Europe/Paris
    sudo systemctl enable --now iwd.service
    sudo systemctl enable docker.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
    systemctl --user enable --now hyprpolkitagent
    grep -qxF "$(which zsh)" /etc/shells 2>/dev/null || which zsh | sudo tee -a /etc/shells
    xdg-mime default imv.desktop image/jpeg
    xdg-mime default imv.desktop image/png
    xdg-mime default google-chrome.desktop application/pdf
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop application/html
    xdg-mime default google-chrome.desktop application/octet-stream
}

# ── Run ────────────────────────────────────────────────────────────
log_start "[BOOTSTRAP]"
bootstrap_system
log_done "[BOOTSTRAP]"

log_start "[AUR HELPER]"
install_aur_helper
log_done "[AUR HELPER]"

log_start "[PACKAGES]"
install_packages
log_done "[PACKAGES]"

log_start "[DOTFILES]"
setup_dotfiles
log_done "[DOTFILES]"

log_start "[SYSTEM STATE]"
setup_system_state
log_done "[SYSTEM STATE]"

log_start "[DEV TOOLS]"
install_devtools
log_done "[DEV TOOLS]"
