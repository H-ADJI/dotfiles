gum log -l info "[START] Installing packages"
yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <./requirements.txt
gum log -l info "[DONE] Installing packages"
