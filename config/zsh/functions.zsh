auto_venv () {
  local VENV_DIR_NAME="venv"
  local activate="$VENV_DIR_NAME/bin/activate"
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -f "$activate" ]]; then
      source "$activate"
    fi
  else
    local parentdir="$(dirname $VIRTUAL_ENV)"
    if [[ "$PWD"/ != "$parentdir"/* ]]; then
      deactivate
      if [[ -f "$activate" ]]; then
        source "$activate"
      fi
    fi
  fi
}
add-zsh-hook chpwd auto_venv

zshaddhistory () {
  local line="${1%%$'\n'}"
  local cmd="${line%% *}"
  # [[ "$cmd" != "exit" ]] && \
  #   [[ "$cmd" != "rm" ]] && \
  #   [[ "$(command -v "$cmd")" != "" ]]
  [[ "$cmd" != "exit" ]]
}

enable-agent-forward () {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent)" > /dev/null
  fi
  ssh-add "$SSH_FORWARD_KEY"
}

agent-symlink () {
  if [ -S "$SSH_AUTH_SOCK" ]; then
    case "$SSH_AUTH_SOCK" in
      /tmp/ssh-*/agent.[0-9]* )
        ln -snf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent"
        export SSH_AUTH_SOCK="$HOME/.ssh/agent"
      ;;
    esac
  elif [ -S "$HOME/.ssh/agent" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent"
  fi
}

auto_tmux () {
  local list create_new_session
  if [[ ! $- == *l* ]]; then
    return
  fi
  if [[ -z "$TMUX" ]]; then
    list="$(tmux list-sessions -F \
      '#S: #{session_windows} windows [#{pane_current_command} "#W"]')"
    if [[ -z "$list" ]]; then
      tmux new-session -t "$(flower)"
    fi
    create_new_session="Create New Session"
    list="$list\n$create_new_session:"
    list="$(echo $list | fzf | cut -d: -f1)"
    if [[ "$list" = "$create_new_session" ]]; then
      tmux new-session -t "$(flower)"
    elif [[ -n "$list" ]]; then
      tmux attach-session -t "$list"
    fi
  else
    :
  fi
}

rename-pane-pwd () {
  [[ $- == *m* ]] && printf '\033]2;%s\033\\' "$(pathshorten "$PWD")"
}
add-zsh-hook chpwd rename-pane-pwd

cd-git-root () {
  local root
  root="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ -z "$root" ]] && return
  BUFFER="cd $root"
  zle accept-line
}
zle -N cd-git-root
bindkey '^Gr' cd-git-root

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^Xe' edit-command-line

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

cd-fzf-git () {
  local root result
  root="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ -z "$root" ]] && return
  result="$(cd "$root" && git ls-files 2> /dev/null \
    | sed '/^[^\/]*$/d;s:/[^/]*$::' \
    | uniq | fzf --preview \
    "exa -T -a --git-ignore --group-directories-first \
      --color=always $root/{} | head -200")"
  root=
  zle reset-prompt
  [[ -z "$result" ]] && return
  BUFFER="cd $(git rev-parse --show-toplevel)/$result"
  zle accept-line
}
zle -N cd-fzf-git
bindkey '^Gd' cd-fzf-git

cd-fzf-ghq () {
  local result match
  result="$(ghq list | fzf)"
  zle reset-prompt
  [[ -n "$result" ]] && match="$(ghq list --full-path --exact "$result")"
  [[ -z "$match" ]] && return
  BUFFER="cd $match"
  zle accept-line
}
zle -N cd-fzf-ghq
bindkey '^Gh' cd-fzf-ghq

dein-json () {
  sed 's@\({\|,\)\(\w\+\):@\1"\2":@g' \
    < "$XDG_CACHE_HOME/nvim/dein/cache_nvim"
}

cd-fzf-dein () {
  local plugin
  plugin="$(dein-json | gojq -r '.[0] | keys | .[]' | fzf)"
  cd "$(dein-json | gojq -r ".[0].[\"$plugin\"].path")"
}

accept-line-ext () {
  if [[ -z "$BUFFER" ]]; then
    printf '\033[1A'
    zle accept-line
    return
  fi
  zle _expand_alias
  zle accept-line
}
zle -N accept-line-ext
bindkey '^M' accept-line-ext
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  accept-line-ext
  history-beginning-search-backword-end
  history-beginning-search-forward-end
)

insert-bslash () {
  zle -U '\'
}
zle -N insert-bslash
bindkey '¥' insert-bslash

zsh-clean () {
  rm -f $ZDOTDIR/*.zwc
  rm -f $ZDOTDIR/.zcompdump.*
  rm -f ~/.cache/zsh/compdump*
  rm -rf $XDG_CACHE_HOME/zpm
}

:q () {:}
:w () {:}
:wq () {:}

benchmark () {
  local tempfile=$(mktemp)
  repeat ${1:-10} { time zsh -i -c exit } 2>&1 2>$tempfile
  printf 'average: %ss maximum: %ss\n' $(awk \
   '{
      secs[NR] = $7
      if (secs[NR] >= max) {
        max = secs[NR]
      }
    }
    END {
      for (i = 1; i < length(secs); i++) {
        sum += secs[i]
      }
      print sum/NR, max
    }' $tempfile)
}
