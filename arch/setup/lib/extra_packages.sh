set -euo pipefail
trap 'echo "[FAIL] $(basename $0) line $LINENO" >&2' ERR

gum log -l info "[START] extra packages"

mise i --locked
nvim --headless -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins

gum log -l info "[DONE] extra packages"
