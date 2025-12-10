#!/bin/sh
alias zshconfig="cd ~/zsh && nv"
alias zbench="time zsh -i -c exit"
alias xel="fc"
alias fix_history="rm ~/.zsh_history && cp ~/dotfiles/zsh/.zsh_history ~"
alias sync_history="cp ~/.zsh_history ~/dotfiles/zsh/"

# Remap Ctrl-A and Ctrl-E
# bindkey "^x^l" end-of-line
# bindkey '^x^h' beginning-of-line
