gum log -l info "[START] Linking dots"

rm -rf "$HOME/.config/hypr"

cp ~/dotfiles/arch/zsh/dot-zsh_history ~/.zsh_history

for dir in "$HOME"/dotfiles/arch/*/; do
    echo "package"
    stow --dotfiles --adopt -d "$HOME/dotfiles/arch" -t "$HOME" "$(basename "$dir")"
done

ssh_private_key="$HOME/.ssh/ssh_git"
eval "$(ssh-agent -s)"
chmod 600 "$ssh_private_key"
ssh-add "$ssh_private_key"

gum log -l info "[DONE] Linking dots"
