# Extending completions path
[ ! -d "$HOME/.zfunc" ] && mkdir "$HOME/.zfunc"
fpath+=~/.zfunc

# importing completion loader
autoload -Uz compinit
# loading completions
compinit

# Case insensitive completion match
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# to cycle through suggestion using tab - overwriten when using fzf-tab
zstyle ':completion:*' menu select
