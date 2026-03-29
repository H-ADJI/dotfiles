# Extending completions path
fpath+=~/.zfunc

# importing completion loader
autoload -Uz compinit
# loading completions
compinit

# Case insensitive completion match
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
