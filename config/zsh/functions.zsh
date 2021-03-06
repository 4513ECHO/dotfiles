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
hook::git_auto_save() {
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
      && echo "Git auto save!"
  fi
}
add-zsh-hook preexec hook::git_auto_save

zshaddhistory () {
  local line="${1%%$'\n'}"
  local cmd="${line%% *}"
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

hook::rename-title () {
  [[ $- == *m* ]] && printf '\033]2;%s\033\\' "$(pathshorten "$PWD")"
}
add-zsh-hook chpwd hook::rename-title

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

widget::cd::git () {
  local root result
  root="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ -z "$root" ]] && return
  result="$(cd "$root" && git ls-files 2> /dev/null \
    | sed '/^[^\/]*$/d;s:/[^/]*$::' \
    | uniq | fzf --preview \
    "exa -T -a --git-ignore --group-directories-first \
      --color=always $root/{} | head -200")"
  zle reset-prompt
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

widget::key::accept () {
  if [[ -z "$BUFFER" ]]; then
    printf '\033[1A'
  fi
  zle _expand_alias
  zle accept-line
}
zle -N widget::key::accept
bindkey '^M' widget::key::accept
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  widget::key::accept
  history-beginning-search-backword-end
  history-beginning-search-forward-end
)

widget::key::bslash () {
  zle -U '\'
}
zle -N widget::key::bslash
bindkey '??' widget::key::bslash

widget::key::space () {
  zle _expand_alias
  zle self-insert
}
zle -N widget::key::space
bindkey ' ' widget::key::space

zsh-clean () {
  rm -f $ZDOTDIR/*.zwc
  rm -f $ZDOTDIR/.zcompdump.*
  rm -rf $ZDOTDIR/.zcompcache
  rm -f ~/.cache/zsh/compdump*
  rm -rf $XDG_CACHE_HOME/zpm
}
