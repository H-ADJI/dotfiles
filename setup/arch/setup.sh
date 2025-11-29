#!/bin/bash
_checkCommandExists() {
    package="$1"
    if ! command -v "$package" >/dev/null; then
        return 1
    else
        return 0
    fi
}
_installYay() {
    [ ! -d "yay" ] && git clone --depth 1 https://aur.archlinux.org/yay.git
    cd "yay" || return 1
    makepkg -si --noconfirm
    cd || return 1
}
install_AUR_helper() {
    cd || exit 1
    if _checkCommandExists "yay"; then
        gum log -l info ":: yay is already installed"
    else
        gum log -l info ":: The installer requires yay. yay will be installed now"
        _installYay
    fi
}
installpackages() {
    while read package; do
        gum log -l info "[START] Installing $package"
        yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout "$package" >>~/yay.log 2>&1
        gum log -l info "[DONE] Installing $package"
    done <~/dotfiles/setup/arch/packages.txt
}
post_install() {
    gum log -l info "[START] Chosing stable rust toolchain release"
    rustup default stable
    gum log -l info "[DONE] Chosing stable rust toolchain release"

    gum log -l info "[START] Installing TPM"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    gum log -l info "[DONE] Installing TPM"

    gum log -l info "[START] transcrypt decryption"
    decrypt_secrets
    gum log -l info "[DONE] transcrypt decryption"

    gum log -l info "[START] Linking dots"
    link_dotfiles
    gum log -l info "[DONE] Linking dots"

    gum log -l info "[START] install tmux plugins"
    sh ~/.tmux/plugins/tpm/bin/install_plugins
    gum log -l info "[DONE] install tmux plugins"

    gum log -l info "[START] ssh setup"
    ssh_setup
    gum log -l info "[DONE] ssh setup"

    gum log -l info "[START] docker post install steps"
    docker_post_install
    gum log -l info "[DONE] docker post install steps"

    gum log -l info "[START] Clone some repos"
    personal_repos
    gum log -l info "[DONE] Clone some repos"

    gum log -l info "[START] Set timezone"
    sudo timedatectl set-timezone Europe/Paris
    gum log -l info "[DONE] Set timezone"

    gum log -l info "[START] Enable iwd service"
    sudo systemctl enable --now iwd.service
    gum log -l info "[DONE] Enable iwd service"

    gum log -l info "[START] Enable docker service"
    sudo systemctl enable docker.service
    gum log -l info "[DONE] Enable docker service"

    gum log -l info "[START] Enable NetworkManager service"
    sudo systemctl enable NetworkManager.service
    gum log -l info "[DONE] Enable NetworkManager service"

    gum log -l info "[START] Enable bluetooth service"
    sudo systemctl enable bluetooth.service
    gum log -l info "[DONE] Enable bluetooth service"

    gum log -l info "[START] Default apps"
    xdg-mime default mupdf.desktop application/pdf
    xdg-mime default imv.desktop image/jpg
    xdg-mime default imv.desktop image/png
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    gum log -l info "[DONE] Default apps"
    gum log -l info "[START] installing multiple uv python versions"
    py_versions=(
        "3.12"
        "3.11"
        "3.10"
        "3.9"
    )
    uv python install "${py_versions[@]}"
    gum log -l info "[DONE] Installing multiple uv python versions"

    gum log -l info "[START] nvim headless install"
    nvim --headless -c 'Lazy install' -c 'qa'
    gum log -l info "[DONE] nvim headless install"

    gum log -l info "[START] Change shell to use ZSH"
    chsh -s "$(grep -E 'zsh$' /etc/shells | head -n1)"
    gum log "[DONE] Change shell to use ZSH"
}
decrypt_secrets() {
    cd ~/dotfiles/ || return 1
    VERIFY=1
    STORED_HASH=$(cat setup/lock.secure)
    while true; do
        MASTER_PASSWORD=$(
            gum input --prompt "Master Password> " --password
        )
        COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
        if [ "$VERIFY" -eq 0 ]; then
            break
        fi
        if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
            gum log -l info "✅ Correct password"
            break
        else
            gum log -l error "❌ Wrong password, try again"
        fi
    done
    transcrypt -y -p "$MASTER_PASSWORD"
    cd || return 1
}
link_dotfiles() {
    cd ~/dotfiles/ || return 1
    dotfiles=(
        "alacritty"
        "swappy"
        "gocheat"
        "direnv"
        "fastfetch"
        "fuzzel"
        "git"
        "sway"
        "leetcode"
        "mako"
        "nvim"
        "qutebrowser"
        "ruff"
        "ssh"
        "starship"
        "systemd"
        "tmux"
        "wlogout"
        "waybar"
        "scripts"
        "zsh"
        "sunsetr"
        "assets"
        "yazi"
    )
    stow --adopt --dotfiles "${dotfiles[@]}"
    cd || return 1
}
docker_post_install() {
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
}
ssh_setup() {
    local ssh_private_key="$HOME/.ssh/ssh_git"
    eval "$(ssh-agent -s)"
    chmod 600 "$ssh_private_key"
    ssh-add "$ssh_private_key"

}
personal_repos() {
    projects=(
        "neurogenesis"
        "secondBrain"
        "dicli"
        "presentations"
        "homelab"
    )
    for PROJECT in "${projects[@]}"; do
        [ ! -d "$PROJECT" ] && git clone "git@github.com:H-ADJI/$PROJECT.git"
    done
    cd ~/dotfiles/ || return 1
    git remote remove origin
    git remote add origin git@github.com:H-ADJI/dotfiles.git
    cd || exit 1
}

sudo --validate
# TODO: handle history sync
install_AUR_helper
installpackages
post_install
