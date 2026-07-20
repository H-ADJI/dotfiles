#!/bin/env bash
set -euo pipefail
trap 'echo "[FAIL] main.sh line $LINENO" >&2' ERR

BRANCH="${1:-master}"
DOTFILES="$HOME/dotfiles"

# ── Bootstrap ──────────────────────────────────────────────────────
sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout \
    base-devel git vim go gum

[ ! -d "$DOTFILES" ] && git clone --branch "$BRANCH" https://github.com/H-ADJI/dotfiles "$DOTFILES"

# ── AUR Helper ─────────────────────────────────────────────────────
install_aur_helper() {
    if command -v yay &>/dev/null; then
        gum log -l info "yay already installed, skipping"
        return
    fi
    YAY_DIR="/tmp/yay"
    git clone --depth 1 https://aur.archlinux.org/yay.git "$YAY_DIR"
    (cd "$YAY_DIR" && makepkg -si --noconfirm)
    rm -rf "$YAY_DIR"
}

# ── Core Packages ──────────────────────────────────────────────────
install_packages() {
    REQ_DIR="$DOTFILES/arch/setup/packages"
    sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
        <"$REQ_DIR/pacman.txt"
    yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
        <"$REQ_DIR/aur.txt"
}

# ── Dotfiles ───────────────────────────────────────────────────────
setup_dotfiles() {
    gum log -l info "Switching remote to SSH"
    git -C "$DOTFILES" remote remove origin
    git -C "$DOTFILES" remote add origin git@github.com:H-ADJI/dotfiles.git

    STORED_HASH="4bf69f1718ef5130a05c4d01b363b1ca65ef92081449e24cc1d37fe7a9a07c69"

    while true; do
        MASTER_PASSWORD=$(
            gum input --prompt "Master Password> " --password
        )
        COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
        if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
            gum log -l info "Correct password"
            break
        else
            gum log -l error "Wrong password, try again"
        fi
    done

    gum log -l info "Decrypting secrets"
    (cd "$DOTFILES" && transcrypt --display &>/dev/null) || (cd "$DOTFILES" && transcrypt -y -p "$MASTER_PASSWORD")

    rm -rf "$HOME/.config/hypr"
    cp "$DOTFILES/arch/zsh/dot-zsh_history" "$HOME/.zsh_history"

    gum log -l info "Stowing dotfiles"
    for dir in "$DOTFILES"/arch/*/; do
        stow --dotfiles --adopt -d "$DOTFILES/arch" -t "$HOME" "$(basename "$dir")" 2>/dev/null
    done

    ssh_private_key="$HOME/.ssh/ssh_git"
    gum log -l info "Starting SSH agent"
    eval "$(ssh-agent -s)" &>/dev/null
    chmod 600 "$ssh_private_key"
    ssh-add "$ssh_private_key" &>/dev/null

    projects_dir="$HOME/projects"
    mkdir -p "$projects_dir"
    projects=(ccraft homelab neurogenesis secondBrain zmk-config learn_nix)
    for project in "${projects[@]}"; do
        [ ! -d "$projects_dir/$project" ] && git clone -q --depth 1 "git@github.com:H-ADJI/$project.git" "$projects_dir/$project"
    done
    gum log -l info "Projects cloned"
}

# ── Extra Packages ─────────────────────────────────────────────────
install_devtools() {
    gum log -l info "Installing mise tools"
    mise i --locked -q
    gum log -l info "Installing nvim plugins"
    nvim --headless -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa' &>/dev/null
    gum log -l info "Installing TPM plugins"
    local TPM_DIR="$HOME/.tmux/plugins/tpm"
    [ ! -d "$TPM_DIR" ] && git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    bash ~/.tmux/plugins/tpm/bin/install_plugins &>/dev/null
}

# ── Extra Packages ─────────────────────────────────────────────────
install_extras() {
    if systemd-detect-virt -c &>/dev/null; then
        gum log -l info "Container detected, skipping extra packages"
        return
    fi
    gum log -l info "[START] Installing extra pacman packages"
    sudo pacman -S --noconfirm --needed --disable-download-timeout - \
        <"$DOTFILES/arch/setup/packages/pacman-extra.txt"
    gum log -l info "[DONE] Extra pacman packages"
    gum log -l info "[START] Installing extra AUR packages"
    yay -S --noconfirm --needed --disable-download-timeout - \
        <"$DOTFILES/arch/setup/packages/aur-extra.txt"
    gum log -l info "[DONE] Extra AUR packages"
}

# ── System State ───────────────────────────────────────────────────
setup_system_state() {
    if ! command -v systemctl &>/dev/null || [ ! -d /run/systemd/system ]; then
        gum log -l info "Not running under systemd, skipping system state"
        return
    fi

    sudo usermod -aG docker "$USER"
    sudo timedatectl set-timezone Europe/Paris
    sudo systemctl enable --now iwd.service
    sudo systemctl enable docker.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
    systemctl --user enable --now hyprpolkitagent
    which zsh | sudo tee -a /etc/shells
    xdg-mime default imv.desktop image/jpeg
    xdg-mime default imv.desktop image/png
    xdg-mime default google-chrome.desktop application/pdf
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop application/html
    xdg-mime default google-chrome.desktop application/octet-stream
}

# ── Run ────────────────────────────────────────────────────────────
gum log -l info "[START] aur_helper"
install_aur_helper
gum log -l info "[DONE] aur_helper"

gum log -l info "[START] packages"
install_packages
gum log -l info "[DONE] packages"

gum log -l info "[START] dotfiles"
setup_dotfiles
gum log -l info "[DONE] dotfiles"

gum log -l info "[START] extra_packages"
install_devtools
gum log -l info "[DONE] extra_packages"

gum log -l info "[START] system_state"
setup_system_state
gum log -l info "[DONE] system_state"

gum log -l info "[START] extras"
install_extras
gum log -l info "[DONE] extras"
