SETUP_DIR="dotfiles/arch/setup/lib"

gum log -l info "[START] Installing packages"
yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <"$SETUP_DIR/requirements.txt"
gum log -l info "[DONE] Installing packages"
