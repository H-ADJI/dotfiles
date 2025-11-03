if ! command -v nvim >/dev/null 2>&1; then
    print "neovim : nvim command not found. Please install nvim ." >&2
    return 1
fi
alias nv="nvim"
alias nvconfig="cd ~/.config/nvim && nv"
alias telescope_clear_cache="rm ~/.local/state/nvim/shada/main.shada"
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
fi
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export FCEDIT="nvim"
alias e='$EDITOR'
if [ "$TERM" = "alacritty" ]; then
    export TERM=xterm-256color
fi
export MANPAGER="nvim +Man!"
