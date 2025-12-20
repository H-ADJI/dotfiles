export AICHAT_MESSAGES_FILE="$HOME/messages.md"
aises() {
    aichat -s "$(basename "$(pwd)")"
}
