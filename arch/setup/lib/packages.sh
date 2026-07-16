SETUP_DIR="dotfiles/arch/setup/lib"

gum log -l info "[START] Installing packages"
sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <"$SETUP_DIR/requirements-pacman.txt"
yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <"$SETUP_DIR/requirements-aur.txt"
gum log -l info "[DONE] Installing packages"
