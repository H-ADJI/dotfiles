SPIDERS_CACHE_DIR="$HOME/.local/share/scrapy"
[ ! -d "$SPIDERS_CACHE_DIR" ] && mkdir -p "$SPIDERS_CACHE_DIR"
cache_file="$SPIDERS_CACHE_DIR/spiders.cache"
alias show_spiders_list="bat ~/.local/share/scrapy/spiders.cache 2>/dev/null"
alias delete_spiders_list="rm ~/.local/share/scrapy/spiders.cache"
alias uv_arch_bezier_fix="BEZIER_NO_EXTENSION=true uv pip install --upgrade bezier --no-binary=bezier numpy==1.26.4"

load_spiders_list() {
    touch "$cache_file"
    if command -v scrapy &>/dev/null; then
        scrapy list 2>/dev/null 1>"$cache_file"
    else
        print -P "\n%F{yellow} Couldn't generate spiders cache, $(pwd) is not a scrapy project%f"
        return 1
    fi
}
fzf_spiders() {
    # Run FZF with a custom appearance
    print -P "\n%F{yellow}Using cached spider list (Last update: $(date -r "$cache_file" '+%m-%d-%Y %H:%M:%S' 2>/dev/null))%f"
    # zle redisplay
    local spider
    spider=$(
        fzf --height 40% --layout=reverse \
            --border --prompt="Select Spider: " --pointer="▶ " --marker="✔ " \
            --preview="echo 'Spider: {}'" --preview-window=down:1:wrap <"$cache_file"
    )
    # Insert the selected spider name into the command line
    if [ -n "$spider" ]; then
        LBUFFER="${LBUFFER}${spider} "
    fi
    zle redisplay
}
# Define the widget and bind it to Ctrl+f
zle -N fzf_spiders
bindkey '^x^f' fzf_spiders

shub_deploy() {
    shub image upload "$SHUB_DEVZONE" --build-arg PYPI_SECRET="$PYPI_SECRET"
}
shub_deploy_shortcut() {
    shub_deploy
    zle redisplay
}
zle -N shub_deploy_shortcut
bindkey '^x^u' shub_deploy_shortcut

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
