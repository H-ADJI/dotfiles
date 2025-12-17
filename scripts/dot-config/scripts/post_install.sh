#!/usr/bin/env bash

gum log -l info "[START] Installing packages"
yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - <~/dotfiles/setup/arch/post_install.txt >>~/yay.log 2>&1
gum log -l info "[DONE] Installing packages"

gum log -l info "[START] Default apps"
xdg-mime default mupdf.desktop application/pdf
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/png
xdg-mime default google-chrome.desktop x-scheme-handler/https
xdg-mime default google-chrome.desktop x-scheme-handler/http
gum log -l info "[DONE] Default apps"

gum log -l info "[START] Chosing stable rust toolchain release"
rustup default stable
gum log -l info "[DONE] Chosing stable rust toolchain release"

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
chsh -s "$(which zsh)"
gum log -l info "[DONE] Change shell to use ZSH"

gum log -l info "[START] copy ZSH history"
cp ~/dotfiles/zsh/.zsh_history ~
gum log -l info "[DONE] copy ZSH history"
