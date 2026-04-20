bezier_python_bininstall() {
    uv pip uninstall bezier
    BEZIER_NO_EXTENSION=true uv pip install --upgrade bezier --no-binary=bezier
    uv pip install numpy==1.26.4
}

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
# running a spider inside docker
docker_spider() {
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <units> <spider_name> [any additional scrapy args]"
        echo "Example: $0 2 my_spider -a crawl_id=1337"
        return
    fi
    # Arguments
    UNITS=$1
    SPIDER_NAME=$2
    EXTRA_ARGS="${@:3}" # all remaining args after the second

    # Compute resources
    MEMORY=$((UNITS * 1024))M # 1 unit = 1GB RAM

    # Run the container with the specified resources
    echo "Running spider '$SPIDER_NAME' with $UNITS unit(s) ($MEMORY RAM, $CPUS CPU)..."

    docker image build -t test_docker_spider --build-arg PYPI_SECRET="$PYPI_SECRET" .
    docker container run --cpus="$UNITS" --memory="$MEMORY" \
        --env-file .env --env V4_PROXIES="$V4_PROXIES" \
        --env GOOGLE_APPLICATION_CREDENTIALS_BANNERS_IMAGES="$GOOGLE_APPLICATION_CREDENTIALS_BANNERS_IMAGES" \
        --env GOOGLE_APPLICATION_CREDENTIALS="$GOOGLE_APPLICATION_CREDENTIALS" \
        test_docker_spider scrapy crawl $SPIDER_NAME $EXTRA_ARGS

}
