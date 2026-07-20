set -euo pipefail
trap 'echo "[FAIL] $(basename $0) line $LINENO" >&2' ERR

gum log -l info "Installing mise tools"
mise i --locked -q
gum log -l info "Installing nvim plugins"
nvim --headless -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa' &>/dev/null
gum log -l info "Installing TPM plugins"
git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins &>/dev/null
