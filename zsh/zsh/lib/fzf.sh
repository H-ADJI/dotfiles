# Set up fzf key bindings and fuzzy completion
_evalcache fzf --zsh
# -- Use fd instead of fzf --
# export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --strip-cwd-prefix --exclude .git"
# #
# # # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# # # - The first argument to the function ($1) is the base path to start traversal
# # # - See the source code (completion.{bash,zsh}) for the details.
# _fzf_compgen_path() {
#     fdfind --hidden --exclude .git . "$1"
# }
# #
# # # Use fd to generate the list for directory completion
# _fzf_compgen_dir() {
#     fdfind --type=d --hidden --exclude .git . "$1"
# }
# show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else batcat -n --color=always --line-range :500 {}; fi"
# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
# # Advanced customization of fzf options via _fzf_comprun function
# # - The first argument to the function is the name of the command.
# # - You should make sure to pass the rest of the arguments to fzf.
# _fzf_comprun() {
#     local command=$1
#     shift
#
#     case "$command" in
#         cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
#         export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
#         ssh)          fzf --preview 'dig {}'                   "$@" ;;
#         *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
#     esac
# }
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# export FZF_DEFAULT_OPTS=" \
    # --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    # --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    # --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    # --color=selected-bg:#45475a \
    # --multi"
