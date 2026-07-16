gum log -l info "[START] Clone projects"

cd ~/dotfiles/ || exit 1

VERIFY=1
STORED_HASH="4bf69f1718ef5130a05c4d01b363b1ca65ef92081449e24cc1d37fe7a9a07c69"

while true; do
    MASTER_PASSWORD=$(
        gum input --prompt "Master Password> " --password
    )
    COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
    if [ "$VERIFY" -eq 0 ]; then
        break
    fi
    if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
        gum log -l info "✅ Correct password"
        break
    else
        gum log -l error "❌ Wrong password, try again"
    fi
done

transcrypt -y -p "$MASTER_PASSWORD"

cd || exit 1
projects_dir="$HOME/projects"
mkdir "$projects_dir"
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

cd ~/dotfiles/ || exit 1
git remote remove origin
git remote add origin git@github.com:H-ADJI/dotfiles.git
cd || exit 1

gum log -l info "[DONE] Clone projects"
