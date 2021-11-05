if [[ ! -f $ZDOTDIR/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$ZDOTDIR/.zinit" && command chmod g-rwX "$ZDOTDIR/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$ZDOTDIR/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

[[ ! -d "$ZDOTDIR/.zinit/completions" ]] && mkdir "$ZDOTDIR/.zinit/completions"
[[ ! -d "$ZDOTDIR/.zinit/polaris" ]] && mkdir "$ZDOTDIR/.zinit/polaris"
source "$ZDOTDIR/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


zinit light-mode for \
  UncleClapton/z-a-bin-gem-node

zinit wait lucid light-mode for \
  atinit'ZINIT[COMPINIT_OPTS]=-C; zicdreplay' \
  atload'fast-theme forest > /dev/null' \
    'zdharma-continuum/fast-syntax-highlighting' \
  blockf \
    'zsh-users/zsh-completions' \
  atload'_zsh_autosuggest_start' \
    'zsh-users/zsh-autosuggestions' \
  atinit'STICKY_TABLE=jis' \
    '4513echo/zsh-sticky-shift' \
  sbin'fzf-tmux' pick'bin/fzf-tmux' \
  multisrc'shell/{completion,key-bindings}.zsh' \
    'junegunn/fzf'

zinit wait lucid from'github-rel' light-mode for \
  sbin'fzf' 'junegunn/fzf' \
  sbin'jq' 'stedolan/jq' \
  sbin'ghq' 'x-motemen/ghq' \
  sbin'gh' 'cli/cli'

