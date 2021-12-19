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

export SSH_FORWARD_KEY="$HOME/.ssh/id_git_rsa"
export SSH_SYMLINK_SOCK="$HOME/.ssh/agent"
[[ -f "$SSH_FORWARD_KEY" ]] && enable-agent-forward

export LOADED_ZSHRC=true

if type zprof > /dev/null; then
  zprof | vim -
fi
