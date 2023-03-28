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

[[ $- == *l* ]] || return

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
  for f in $(find $ZDOTDIR/ -type f -name '*.zsh') $ZDOTDIR/.zshrc $HOME/.zshenv; do
    if [[ ! -f "$f.zwc" ]] || [[ "$f" -nt "$f.zwc" ]]; then
      { zcompile "$f" } &!
    fi
  done
}

if [[ -n "$TMUX" ]]; then
  hook::venv
  hook::rename-title
fi
[[ -f '~/.ssh/id_git_ed25519' ]] && enable-agent-forward '~/.ssh/id_git_ed25519'
[[ -z "$MINIMUM_DOTFILES" ]] && agent-symlink
[[ ! -f "$HISTFILE" ]] && { mkdir -p "$(dirname "$HISTFILE")" && touch "$HISTFILE"; }
[[ ! -d "$XDG_RUNTIME_DIR" ]] && { mkdir -p "$XDG_RUNTIME_DIR" 2> /dev/null && chmod 0700 "$XDG_RUNTIME_DIR"; }

type dircolors > /dev/null && source <(dircolors -b "$ZDOTDIR/dircolors")
type afx > /dev/null && source <(afx init)
type zoxide > /dev/null && source <(zoxide init zsh)

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --marker='*'"
if type fd > /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --exclude '.git'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --follow --hidden --exclude '.git'"
fi

if type zprof > /dev/null; then
  zprof | less
elif [[ "$TERM" = 'linux' ]]; then
  echo -n 'You are using virtual console directly. Start X server? [y/N] '
  read -q && xinit
elif [[ $SHLVL -eq 1 ]] && [[ -z "$MINIMUM_DOTFILES" ]] && [[ -z "$LOADED_ZSHRC" ]]; then
  widget::tmux::session
fi
export LOADED_ZSHRC=true
