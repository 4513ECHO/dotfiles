bindkey -e
autoload -Uz add-zsh-hook

if [[ -f ~/.minimum_dotfiles ]]; then
  export MINIMUM_DOTFILES=true
fi

() {
  for rc in $ZDOTDIR/*.zsh; do
    source "$rc"
  done
}

() {
  autoload -Uz compinit
  : ${ZSH_COMPDUMP:=$XDG_CACHE_HOME/zsh/compdump-$(hostname)-$ZSH_VERSION}
  local dump=$ZSH_COMPDUMP
  local dumpc=${dump}.zwc
  # re-check dump file that are older than 24 hours
  if [[ -n $dump(#qN.mh+24) ]]; then
    compinit -i -d "$dump"
    { rm -rf "$dumpc" && zcompile "$dump" } &!
  else
    compinit -C -d "$dump"
    { [[ ! -s $dumpc || $dump -nt $dumpc ]] && rm -rf "$dumpc" && zcompile "$dump" } &!
  fi
  for f in $(find $ZDOTDIR/ -type f -name '*.zsh') $ZDOTDIR/.zshrc; do
    if [[ ! -f "$f.zwc" ]] || [[ "$f" -nt "$f.zwc" ]]; then
      { zcompile "$f" } &!
    fi
  done
}

export SSH_FORWARD_KEY="$HOME/.ssh/id_git_ed25519"
export SSH_SYMLINK_SOCK="$HOME/.ssh/agent"
[[ -f "$SSH_FORWARD_KEY" ]] && enable-agent-forward
[[ -z "$MINIMUM_DOTFILES" ]] && agent-symlink
[[ $SHLVL -eq 1 ]] && [[ -z "$MINIMUM_DOTFILES" ]] \
  && [[ -z "$LOADED_ZSHRC" ]] && auto_tmux
if [[ -n "$TMUX" ]]; then
  auto_venv
  rename-pane-pwd
fi

if type dircolors > /dev/null; then
  eval "$(dircolors $ZDOTDIR/dircolors)"
fi

if type fd > /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --exclude '.git'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --follow --hidden --exclude '.git'"
fi

export LOADED_ZSHRC=true

if type zprof > /dev/null; then
  zprof | vim -
fi
