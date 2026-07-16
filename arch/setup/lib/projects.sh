gum log -l info "[START] Clone projects"

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
