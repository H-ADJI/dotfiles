if [[ ! -f "$HOME/.zfunc/_zellij" ]]; then
    zellij setup --generate-completion zsh >"$HOME/.zfunc/_zellij"
fi
