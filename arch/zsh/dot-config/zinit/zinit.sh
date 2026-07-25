# zinit installation
# shellcheck disable=all
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME"/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
COMPLETIONS_DIR="${HOME}/.cache/zinit/completions"
[ ! -d "$COMPLETIONS_DIR" ] && mkdir -p "$COMPLETIONS_DIR"
source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-completions"
zinit light "mroth/evalcache"
zinit light "Aloxaf/fzf-tab"

# add git function library https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
zinit snippet OMZL::git.zsh

# usefull git aliases and function https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
zinit snippet OMZP::git

# run current or previous commands with sudo https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
zinit snippet OMZP::sudo

# replace ls with eza and its aliases https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/eza
zinit snippet OMZP::eza

# gh CLI completions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh
zinit snippet OMZP::gh

# uv aliases and completions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/uv
zinit snippet OMZP::uv

# ssh host completions and utility functions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh
zinit snippet OMZP::ssh

# docker aliases and completions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# podman aliases and completions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/podman
zinit snippet OMZP::podman
