_evalcache mise activate zsh
if [[ ! -f "$HOME/.zfunc/_mise" ]]; then
    mise completion zsh >"$HOME/.zfunc/_mise"
fi
