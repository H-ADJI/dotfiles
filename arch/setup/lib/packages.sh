set -euo pipefail
trap 'echo "[FAIL] $(basename $0) line $LINENO" >&2' ERR
REQ_DIR="$HOME/dotfiles/arch/setup/packages"

gum log -l info "[START] Installing packages"
sudo pacman -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <"$REQ_DIR/requirements-pacman.txt"
yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout - \
    <"$REQ_DIR/requirements-aur.txt"
gum log -l info "[DONE] Installing packages"
