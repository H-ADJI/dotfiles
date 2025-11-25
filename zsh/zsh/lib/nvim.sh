if ! command -v nvim >/dev/null 2>&1; then
    print "neovim : nvim command not found. Please install nvim ." >&2
    return 1
fi
alias nv="nvim"
alias nvconfig="cd ~/.config/nvim && nv"
alias nvim_shada_clear="rm ~/.local/state/nvim/shada/main.shada"
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
export MANPAGER="nvim +Man!"
