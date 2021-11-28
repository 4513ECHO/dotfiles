[[ -n "$MINIMUM_DOTFILES" ]] && return

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
  as'program' pick'bin/fzf-tmux' \
  multisrc'shell/{completion,key-bindings}.zsh' \
    'junegunn/fzf' \
  asload'_lazyload_settings' \
    'qoomon/zsh-lazyload'

zinit ice wait lucid as'completion' cp'git-completion.zsh -> _git'
zinit snippet https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

_lazyload_settings () {
  :
  # lazyload pip -- 'source <(pip completion --zsh)'
}

# zinit wait lucid from'github-rel' as'null' light-mode for \
#   sbin 'junegunn/fzf' \
#   sbin 'stedolan/jq' \
#   sbin 'x-motemen/ghq' \
