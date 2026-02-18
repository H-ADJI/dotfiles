if ! command -v nvim >/dev/null 2>&1; then
    print "neovim : nvim command not found. Please install nvim ." >&2
    return 1
fi
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
fi
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export FCEDIT="nvim"
# export MANPAGER="nvim +Man!"
