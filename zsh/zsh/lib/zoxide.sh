if command -v zoxide >/dev/null 2>&1; then
    export ZOXIDE_CMD_OVERRIDE="cd"
    _evalcache zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh
else
    echo 'zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi
# cd just by typing name
# setopt autocd
