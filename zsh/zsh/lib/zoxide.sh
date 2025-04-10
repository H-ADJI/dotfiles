export ZOXIDE_CMD_OVERRIDE="cd"
if command -v zoxide >/dev/null 2>&1; then
    _evalcache zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh
else
    echo '[oh-my-zsh] zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi
# cd just by typing name
setopt autocd
