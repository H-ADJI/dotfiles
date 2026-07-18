# starship prompt customization (should be first)
# shellcheck disable=all
source ~/zsh/lib/starship.sh
source ~/zsh/zinit/zinit.sh
source ~/zsh/lib/aichat.sh
source ~/zsh/lib/aliases.sh
source ~/zsh/lib/bat.sh
source ~/zsh/lib/completions.sh
source ~/zsh/lib/fzf.sh
source ~/zsh/lib/history.sh
source ~/zsh/lib/keybinds.sh
source ~/zsh/lib/mise.sh
source ~/zsh/lib/nvim.sh
source ~/zsh/lib/path.sh
source ~/zsh/lib/tv.sh
# source ~/zsh/lib/zellij.sh
source ~/zsh/lib/zoxide.sh

zinit cdreplay -q
