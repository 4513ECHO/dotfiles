autoload -Uz add-zsh-hook

VENV_DIR_NAME="venv"
SSH_KEY="id_git_rsa"
AGENT="$HOME/.ssh/agent"

auto_venv () {
  local activate="$VENV_DIR_NAME/bin/activate"
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -f $activate ]]; then
      source $activate
    fi
  else
    local parentdir="$(dirname $VIRTUAL_ENV)"
    if [[ "$PWD"/ != "$parentdir"/* ]]; then
      deactivate
      if [[ -f $activate ]]; then
        source $activate
      fi
    fi
  fi
}
add-zsh-hook chpwd auto_venv

enable_agent_forward () {
  if [ -z $SSH_AUTH_SOCK ]; then
    eval $(ssh-agent) > /dev/null
  fi
  ssh-add $HOME/.ssh/$SSH_KEY
}

agent_symlink () {
  if [ -S "$SSH_AUTH_SOCK" ]; then
    case "$SSH_AUTH_SOCK" in
      /tmp/ssh-*/agent.[0-9]* )
        ln -snf "$SSH_AUTH_SOCK" "$AGENT"
        export SSH_AUTH_SOCK="$AGENT"
      ;;
    esac
  elif [ -S "$AGENT" ]; then
    export SSH_AUTH_SOCK="$AGENT"
  fi
}

agent_symlink
[ -f $HOME/.ssh/$SSH_KEY ] && [ -f $HOME/.ssh/config ] && enable_agent_forward

auto_tmux () {
  local list create_new_session
  if [[ ! -n $TMUX ]] && [[ $- == *l* ]]; then
    list="$(tmux list-sessions -F '#S: #{session_windows} windows [#W] at #{pane_current_path}')"
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
    else
      :
    fi
  fi
}

auto_tmux

vim_clean () {
  rm -rf ~/.cache/vim/dein
  rm -rf ~/.local/share/vim/vim-lsp-settings/
}

benchmark () {
  local tempfile=$(mktemp)
  repeat 10 { time zsh -i -c exit } 2>&1 2>/$tempfile
  printf 'average: %ss maximum: %ss\n' $(awk \
   '{
      secs[NR] = substr($1, 1, 4)
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
}

sticky-shift () {
  local char result
  typeset -A sticky_table special_table
  sticky_table=(
    "'1'" '!' "'2'" '"' "'3'" '#' "'4'" '$' "'5'" '%' "'6'" '&' "'7'" \'
    "'8'" '(' "'9'" ')' "'-'" '=' "'^'" '~' "'¥'" '|' "'@'" '`' "'['" '{'
    "';'" '+' "':'" '*' "']'" '}' "','" '<' "'.'" '>' "'/'" '?'
  )
  special_table=(
    "' '" ';' "'\x08'" ''
  )
  while :; do
    IFS= read -rk 1 -t 1 char
    if [[ "$char" =~ [a-z] ]]; then
      result="$(echo "$char" | tr '[:lower:]' '[:upper:]')"
      break
    elif [[ -n "${sticky_table[(i)'$char']}" ]]; then
      result="${sticky_table['$char']}"
      break
    elif [[ -n "${special_table[(i)'$char']}" ]]; then
      result="${special_table['$char']}"
      break
    elif [[ $char == $'\x08' ]]; then
      break
    fi
  done
  LBUFFER="$LBUFFER$result"
}
zle -N sticky-shift
bindkey ";" sticky-shift
