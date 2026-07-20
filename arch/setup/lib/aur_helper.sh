set -euo pipefail

gum log -l info "[START] AUR helper"

YAY_DIR="/tmp/yay"
git clone --depth 1 https://aur.archlinux.org/yay.git "$YAY_DIR"
( cd "$YAY_DIR" && makepkg -si --noconfirm )
rm -rf "$YAY_DIR"

gum log -l info "[DONE] AUR helper"
