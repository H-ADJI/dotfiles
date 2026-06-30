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
