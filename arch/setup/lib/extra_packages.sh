mise i --locked
nvim --headless -c 'Lazy install' -c 'MasonToolsInstallSync' -c 'qa'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sh ~/.tmux/plugins/tpm/bin/install_plugins
