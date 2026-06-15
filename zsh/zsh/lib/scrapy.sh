shub_deploy() {
    shub image upload "$SHUB_DEVZONE" --build-arg PYPI_SECRET="$PYPI_SECRET"
}

shub_deploy_shortcut() {
    shub_deploy
    zle redisplay
}

zle -N shub_deploy_shortcut
bindkey '^x^u' shub_deploy_shortcut

clone_job() {
    tmp_file=$(mktemp --suffix=.sh)
    cmd=$(pls job clone --local "$1")
    echo "$cmd --pdb" >&2 >"$tmp_file"
    sh "$tmp_file"
}
