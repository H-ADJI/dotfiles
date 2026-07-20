set -euo pipefail
trap 'echo "[FAIL] $(basename $0) line $LINENO" >&2' ERR

DOTFILES="$HOME/dotfiles"

gum log -l info "Switching remote to SSH"
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

gum log -l info "Decrypting secrets"
(cd "$DOTFILES" && transcrypt --display &>/dev/null) || (cd "$DOTFILES" && transcrypt -y -p "$MASTER_PASSWORD")

rm -rf "$HOME/.config/hypr"

cp ~/dotfiles/arch/zsh/dot-zsh_history ~/.zsh_history

gum log -l info "Stowing dotfiles"
for dir in "$HOME"/dotfiles/arch/*/; do
    stow --dotfiles --adopt -d "$HOME/dotfiles/arch" -t "$HOME" "$(basename "$dir")" 2>/dev/null
done

ssh_private_key="$HOME/.ssh/ssh_git"
gum log -l info "Starting SSH agent"
eval "$(ssh-agent -s)" &>/dev/null
chmod 600 "$ssh_private_key"
ssh-add "$ssh_private_key" &>/dev/null

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
    [ ! -d "$projects_dir/$project" ] && git clone -q --depth 1 "git@github.com:H-ADJI/$project.git" "$projects_dir/$project"
done
gum log -l info "Projects cloned"
