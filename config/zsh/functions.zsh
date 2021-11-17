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
[[ -n "$TMUX" ]] && auto_venv

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

[[ $SHLVL -eq 1 ]] && auto_tmux

rename-pane-pwd () {
  [[ $- == *m* ]] && printf '\033]2;%s\033\\' "$(pathshorten "$PWD")"
}
add-zsh-hook chpwd rename-pane-pwd
[[ -n "$TMUX" ]] && rename-pane-pwd

cd-git-root () {
  local root
  root="$(git rev-parce --show-toplevel 2> /dev/null)"
  [[ -n "$root" ]] && cd "$root"
  zle accept-line
}
zle -N cd-git-root
bindkey "^Gr" cd-git-root

cd-fzf-git () {
  local root result
  root="$(git rev-parce --show-toplevel 2> /dev/null)"
  result="$(cd "$root" && git ls-files | sed '/^[^\/]*$/d;s:/[^/]*$::' \
    | uniq | fzf)"
  zle reset-prompt
  [[ -n "$result" ]] && cd "$root/$result"
  zle accept-line
}
zle -N cd-fzf-git
bindkey "^Gd" cd-fzf-git

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
      for f in $(ls $ZDOTDIR); do
        [[ "$f" =~ *.zsh$ ]] && zcompile "$f"
      done
      for f in $(find $ZDOTDIR/.zinit -name '*.zsh'); do
        zcompile "$f"
      done
  else
    compinit -C -d "$dump"
    { [[ ! -s $dumpc || $dump -nt $dumpc ]] && rm -rf "$dumpc" && zcompile "$dump" } &!
  fi
}

sticky-shift () {
  local char result settings
  typeset -A sticky_table special_table
  sticky_table=(
    "'1'" '!' "'2'" '"' "'3'" '#' "'4'" '$' "'5'" '%' "'6'" '&' "'7'" \'
    "'8'" '(' "'9'" ')' "'-'" '=' "'^'" '~' "'¥'" '|' "'@'" '`' "'['" '{'
    "';'" '+' "':'" '*' "']'" '}' "','" '<' "'.'" '>' "'/'" '?'
  )
  special_table=(
    "' '" ';'
  )
  settings="$(stty -F /dev/tty --save)"
  stty -F /dev/tty erase undef
  while :;do
    IFS="" read -r -k 1 -t 1 char
    if [[ "$char" =~ [a-z] ]]; then
      result="$(echo "$char" | tr '[:lower:]' '[:upper:]')"
      break
    elif [[ -n "${sticky_table[(i)'$char']}" ]]; then
      result="${sticky_table['$char']}"
      break
    elif [[ -n "${special_table[(i)'$char']}" ]]; then
      result="${special_table['$char']}"
      break
    elif [[ $char == $'\x00' ]]; then
      break
    # else # debug
    #   result="failed: $char"
    #   break
    fi
  done
  stty -F /dev/tty "$settings"
  LBUFFER="$LBUFFER$result"
}
zle -N sticky-shift
bindkey ";" sticky-shift
