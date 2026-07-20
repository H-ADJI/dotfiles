set -euo pipefail
trap 'echo "[FAIL] $(basename $0) line $LINENO" >&2' ERR

mise i --locked -q
nvim --headless -c 'lua print("Installing Lazy plugins...")' -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa' &>/dev/null
git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins &>/dev/null
