# history
HISTSIZE=5000
export SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
