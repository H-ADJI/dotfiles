gum log -l info "[START] Linking dots"

dotfiles=(
    "aichat"
    # TODO: migrate to ghostty
    "alacritty"
    "assets"
    "bat"
    "browser"
    "fastfetch"
    "fuzzel"
    "git"
    "hunk"
    "jnv"
    "jqp"
    "leetcode"
    "mise"
    "nvim"
    "pipewire"
    "pulsemixer"
    "ruff"
    "scripts"
    "ssh"
    "starship"
    "sunsetr"
    "swappy"
    "tabiew"
    "task"
    "tmux"
    "tv"
    "walt"
    "ghostty"
    "yazi"
    "zsh"
    "$COMPOSITOR"
)

rm -rf "$HOME/.config/$COMPOSITOR"

cp ~/dotfiles/arch/zsh/dot-zsh_history ~/.zsh_history

stow --dotfiles --adopt -d "$HOME/dotfiles/arch/" -t "$HOME" "${dotfiles[@]}"

ssh_private_key="$HOME/.ssh/ssh_git"
eval "$(ssh-agent -s)"
chmod 600 "$ssh_private_key"
ssh-add "$ssh_private_key"

gum log -l info "[DONE] Linking dots"
