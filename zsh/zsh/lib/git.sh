git_release() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <new_git_tag>"
        echo "Example: $0 5.345.22"
        return 1
    fi
    git commit -am "update changelog" && git tag "$1" && git push && git push origin "$1"
}
