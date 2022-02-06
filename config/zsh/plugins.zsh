[[ -n "$MINIMUM_DOTFILES" ]] && return

[[ $- == *l* ]] || return

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

# usage: __zinit_install_completion {repo} {path} {cmd_name} [{config}]
__zinit_install_completion () {
  zinit ice wait lucid as'completion' atload"compdef _$3 $3" $4
  zinit snippet "https://raw.githubusercontent.com/$1/master/$2"
}

__lazyload_settings () {
  # lazyload pip -- 'source <(pip completion --zsh)'
  __gen_completion_file deno   deno completions zsh
  __gen_completion_file cargo  rustup completions zsh cargo
  __gen_completion_file rustup rustup completions zsh rustup
}

__gen_completion_file () {
  local cmd="$1"
  shift
  eval "$@" > "$ZDOTDIR/completions/_$cmd"
  compdef "_$cmd" "$cmd"
}

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
  asload'__lazyload_settings' \
    'qoomon/zsh-lazyload'

__zinit_install_completion 'git/git' 'contrib/completion/git-completion.zsh' \
  'git' 'cp"git-completion.zsh -> _git"'
__zinit_install_completion 'sharkdp/fd' 'contrib/completion/_fd' 'fd'
__zinit_install_completion 'BurntSushi/ripgrep' 'complete/_rg' 'rg'
__zinit_install_completion 'ogham/exa' 'completions/zsh/_exa' 'exa'
__zinit_install_completion 'x-motemen/ghq' 'misc/zsh/_ghq' 'ghq'

