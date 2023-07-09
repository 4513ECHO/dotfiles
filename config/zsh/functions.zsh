hook::venv() {
  local venv_dir_name=('venv' '.venv')
  local dir activate parentdir
  for dir in "${venv_dir_name[@]}"; do
    activate="$dir/bin/activate"
    if [[ -z "$VIRTUAL_ENV" ]]; then
      if [[ -f "$activate" ]]; then
        source "$activate"
        break
      fi
    else
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]]; then
        deactivate
      elif [[ -f "$activate" ]]; then
        source "$activate"
        break
      fi
    fi
  done
}
add-zsh-hook chpwd hook::venv

# from https://github.com/yuki-yano/dotfiles/blob/7f10462d/.zshrc#L531
# Automatically save the current git state to reflog
hook-git-auto-save () {
  if [[ -d .git ]] && [[ -f .git/auto-save ]] \
    && [[ $(find .git/auto-save -mmin -$((60)) | wc -l) -eq 0 ]] \
    && [[ ! -f .git/MERGE_HEAD ]] \
    && [[ $(git --no-pager diff --cached | wc -l) -eq 0 ]] \
    && [[ ! -f .git/index.lock ]] \
    && [[ ! -d .git/rebase-merge ]] \
    && [[ ! -d .git/rebase-apply ]]; then
    touch .git/auto-save \
      && git add --all \
      && git commit --no-verify --message "Auto save: $(date -R)" >/dev/null \
      && git reset HEAD^ >/dev/null \
      && echo 'Git auto save!'
  fi
}
add-zsh-hook preexec hook-git-auto-save

zshaddhistory () {
  local line="${1%%$'\n'}"
  local cmd="${line%% *}"
  [[ "$cmd" != "exit" ]]
}

enable-agent-forward () {
  [[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent)" > /dev/null
  ssh-add "$1"
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

widget::tmux::session () {
  local list result attach_cmd create_new_session new_session
  list="$(tmux list-sessions -F \
    '#S: #{session_windows} windows [#{pane_current_command} "#W"]' \
    2>/dev/null)"
  if [[ -z "$list" ]]; then
    tmux new-session -t "$(flower)" -d
    list="$(tmux list-sessions -F \
      '#S: #{session_windows} windows [#{pane_current_command} "#W"]' \
      2>/dev/null)"
  fi
  create_new_session='Create New Session'
  result="$(echo "$list\n$create_new_session:" | fzf | cut -d: -f1)"
  if [[ -z "$TMUX" ]]; then
    attach_cmd='attach-session'
  else
    attach_cmd='switch-client'
  fi
  if [[ "$result" = "$create_new_session" ]]; then
    while tmux has-session -t "$new_session" 2>/dev/null; do
      new_session="$(flower)"
    done
    tmux new-session -t "$new_session" -d
    tmux "$attach_cmd" -t "$new_session"
  elif [[ -n "$result" ]]; then
    tmux "$attach_cmd" -t "$result"
  fi
}
zle -N widget::tmux::session
bindkey '^X^T' widget::tmux::session
bindkey '^Xt' widget::tmux::session

hook-set-title () {
  [[ $- == *m* ]] && printf '\033]2;%s\033\\' "$(pathshorten "$PWD")"
}
add-zsh-hook chpwd hook-set-title

widget::cd::git-root () {
  local root
  root="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ -z "$root" ]] && return
  BUFFER="cd $root"
  zle accept-line
}
zle -N widget::cd::git-root
bindkey '^Gr' widget::cd::git-root

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

bindkey '^U' backward-kill-line

widget::cd::git () {
  local root result
  root="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ -z "$root" ]] && return
  result="$(cd "$root" && git ls-files 2> /dev/null \
    | sed '/^[^\/]*$/d;s:/[^/]*$::' \
    | sort -u | fzf)"
  root= zle reset-prompt
  [[ -z "$result" ]] && return
  BUFFER="cd $root/$result"
  zle accept-line
}
zle -N widget::cd::git
bindkey '^Gd' widget::cd::git

widget::cd::ghq () {
  local result match
  result="$(ghq list | fzf)"
  zle reset-prompt
  [[ -n "$result" ]] && match="$(ghq list --full-path --exact "$result")"
  [[ -z "$match" ]] && return
  BUFFER="cd $match"
  zle accept-line
}
zle -N widget::cd::ghq
bindkey '^Gh' widget::cd::ghq

accept-line-extended () {
  [[ -z "$BUFFER" ]] && printf '\033[1A'
  zle _expand_alias
  zle accept-line
}
zle -N accept-line-extended
bindkey '^M' accept-line-extended
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  accept-line-extended
  history-beginning-search-backword-end
  history-beginning-search-forward-end
)

insert-bslach () { zle -U '\'; }
zle -N insert-bslach
bindkey '¥' insert-bslach

insert-space () { zle _expand_alias; zle self-insert; }
zle -N insert-space
bindkey ' ' insert-space

zsh-clean () {
  rm -f $ZDOTDIR/*.zwc
  rm -f $ZDOTDIR/.zcompdump.*
  rm -rf $ZDOTDIR/.zcompcache
  rm -f ~/.cache/zsh/compdump*
  rm -rf $XDG_CACHE_HOME/zpm
}
