[ ! -d "yay" ] && git clone --depth 1 https://aur.archlinux.org/yay.git
cd "yay" || exit 1
makepkg -si --noconfirm
cd || exit 1
