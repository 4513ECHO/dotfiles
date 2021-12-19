auto_venv () {
  local VENV_DIR_NAME="venv"
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
        ln -snf "$SSH_AUTH_SOCK" "$SSH_SYMLINK_SOCK"
        export SSH_AUTH_SOCK="$SSH_SYMLINK_SOCK"
      ;;
    esac
  elif [ -S "$SSH_SYMLINK_SOCK" ]; then
    export SSH_AUTH_SOCK="$SSH_SYMLINK_SOCK"
  fi
}

auto_tmux () {
  local list create_new_session
  if [[ $- == *l* ]]; then
    if [[ -z "$TMUX" ]]; then
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
      fi
    else
      :
    fi
  fi
}

[[ $SHLVL -eq 1 ]] && [[ -z "$MINIMUM_DOTFILES" ]] && auto_tmux

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

zsh_clean () {
  rm -rf $ZDOTDIR/.zinit
  rm -f $ZDOTDIR/*.zwc
  rm -f $ZDOTDIR/.zcompdump
  rm -f ~/.cache/zsh/compdump*
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

type _deno > /dev/null || deno completions zsh > $ZDOTDIR/completions/_deno
