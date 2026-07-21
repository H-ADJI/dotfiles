if command -v zoxide >/dev/null 2>&1; then
    _evalcache zoxide init zsh --cmd cd
else
    echo 'zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi
