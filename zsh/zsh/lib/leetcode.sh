eval "$(leetcode completions)"

leetcode_channel() {
    tv lc
    zle redisplay
}

zle -N leetcode_channel
bindkey '^x^l' leetcode_channel
