set -euo pipefail

gum log -l info "[START] Clone projects"

DOTFILES="$HOME/dotfiles"

git -C "$DOTFILES" remote remove origin
git -C "$DOTFILES" remote add origin git@github.com:H-ADJI/dotfiles.git

STORED_HASH="4bf69f1718ef5130a05c4d01b363b1ca65ef92081449e24cc1d37fe7a9a07c69"

while true; do
    MASTER_PASSWORD=$(
        gum input --prompt "Master Password> " --password
    )
    COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
    if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
        gum log -l info "✅ Correct password"
        break
    else
        gum log -l error "❌ Wrong password, try again"
    fi
done

(cd "$DOTFILES" && transcrypt -y -p "$MASTER_PASSWORD")

rm -rf "$HOME/.config/hypr"

cp ~/dotfiles/arch/zsh/dot-zsh_history ~/.zsh_history

for dir in "$HOME"/dotfiles/arch/*/; do
    stow --dotfiles --adopt -d "$HOME/dotfiles/arch" -t "$HOME" "$(basename "$dir")"
done

ssh_private_key="$HOME/.ssh/ssh_git"
eval "$(ssh-agent -s)"
chmod 600 "$ssh_private_key"
ssh-add "$ssh_private_key"

projects_dir="$HOME/projects"
mkdir -p "$projects_dir"
projects=(
    "ccraft"
    "homelab"
    "neurogenesis"
    "secondBrain"
    "zmk-config"
    "learn_nix"
)
for project in "${projects[@]}"; do
    [ ! -d "$project" ] && git clone --depth 1 "git@github.com:H-ADJI/$project.git" "$projects_dir/$project"
done

gum log -l info "[DONE] Clone projects"
