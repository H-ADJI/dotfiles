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
        base-devel git vim go gum &>/dev/null
    if [ ! -d "$DOTFILES" ]; then
        git clone --branch "$BRANCH" https://github.com/H-ADJI/dotfiles "$DOTFILES"
    fi
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
    local REQ_DIR="$DOTFILES/arch/setup/packages"
    sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
        <"$REQ_DIR/pacman.txt" &>/dev/null
    yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
        <"$REQ_DIR/aur.txt" &>/dev/null
}

setup_dotfiles() {
    log_start "switching remote to SSH"
    git -C "$DOTFILES" remote set-url origin git@github.com:H-ADJI/dotfiles.git 2>/dev/null ||
    git -C "$DOTFILES" remote add origin git@github.com:H-ADJI/dotfiles.git
    log_done "remote switched to SSH"

    local STORED_HASH="4bf69f1718ef5130a05c4d01b363b1ca65ef92081449e24cc1d37fe7a9a07c69"

    local MASTER_PASSWORD COMPUTED_HASH
    while true; do
        MASTER_PASSWORD=$(
            gum input --prompt "Master Password> " --password
        )
        COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
        if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
            log_done "correct password"
            break
        else
            log_error "wrong password, try again"
        fi
    done

    log_start "decrypting secrets"
    (cd "$DOTFILES" && transcrypt --display &>/dev/null) || (cd "$DOTFILES" && transcrypt -y -p "$MASTER_PASSWORD")
    log_done "secrets decrypted"

    rm -rf "$HOME/.config/hypr"
    [ ! -f "$HOME/.zsh_history" ] && cp "$DOTFILES/arch/zsh/dot-zsh_history" "$HOME/.zsh_history"

    log_start "stowing dotfiles"
    for dir in "$DOTFILES"/arch/*/; do
        stow --dotfiles --adopt -d "$DOTFILES/arch" -t "$HOME" "$(basename "$dir")" 2>/dev/null
    done
    log_done "stowing dotfiles"

    local ssh_private_key="$HOME/.ssh/ssh_git"
    if [ -z "${SSH_AUTH_SOCK:-}" ]; then
        log_start "starting SSH agent"
        eval "$(ssh-agent -s)" &>/dev/null
        log_done "SSH agent started"
    fi
    chmod 600 "$ssh_private_key"
    ssh-add -l &>/dev/null || ssh-add "$ssh_private_key" &>/dev/null

    log_start "cloning projects"
    local projects_dir="$HOME/projects"
    mkdir -p "$projects_dir"
    local -a projects=(ccraft homelab neurogenesis secondBrain zmk-config learn_nix)
    for project in "${projects[@]}"; do
        [ ! -d "$projects_dir/$project" ] && git clone -q --depth 1 "git@github.com:H-ADJI/$project.git" "$projects_dir/$project"
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

install_extras() {
    if systemd-detect-virt -c &>/dev/null; then
        log_skip "container detected, skipping extra packages"
        return
    fi
    log_start "installing extra pacman packages"
    sudo pacman -S --noconfirm --needed --disable-download-timeout - \
        <"$DOTFILES/arch/setup/packages/pacman-extra.txt"
    log_done "extra pacman packages installed"
    log_start "installing extra AUR packages"
    yay -S --noconfirm --needed --disable-download-timeout - \
        <"$DOTFILES/arch/setup/packages/aur-extra.txt"
    log_done "extra AUR packages installed"
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

log_start "[CORE PACKAGES]"
install_packages
log_done "[CORE PACKAGES]"

log_start "[DOTFILES]"
setup_dotfiles
log_done "[DOTFILES]"

log_start "[SYSTEM STATE]"
setup_system_state
log_done "[SYSTEM STATE]"

log_start "[EXTRAS]"
install_extras
log_done "[EXTRAS]"

log_start "[DEV TOOLS]"
install_devtools
log_done "[DEV TOOLS]"
