zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

zinit ice as"completion"
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh

zinit wait lucid light-mode for \
                                   "zdharma/fast-syntax-highlighting" \
                                   "zsh-users/zsh-completions" \
    atload"_zsh_autosuggest_start" "zsh-users/zsh-autosuggestions"

