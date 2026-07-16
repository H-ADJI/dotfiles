gum log -l info "[START] AUR helper"

[ ! -d "yay" ] && git clone --depth 1 https://aur.archlinux.org/yay.git
cd "yay" || exit 1
makepkg -si --noconfirm
cd || exit 1

gum log -l info "[DONE] AUR helper"
