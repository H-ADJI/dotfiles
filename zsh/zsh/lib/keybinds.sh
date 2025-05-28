# no vim bindings
bindkey -e

# accept zsh-autosuggestions
bindkey '^o' autosuggest-accept
bindkey '^ ' autosuggest-execute

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# edit current command
autoload edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line
