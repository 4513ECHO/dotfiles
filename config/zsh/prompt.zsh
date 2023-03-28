autoload -Uz vcs_info
[[ $- == *i* ]] || return

export VIRTUAL_ENV_DISABLE_PROMPT=1
function venv-prompt () {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "($(basename "$VIRTUAL_ENV"))"
  else
    echo ''
  fi
}

typeset -gA prompt_colors
prompt_colors[red]=001
prompt_colors[green]=002
prompt_colors[yellow]=003
prompt_colors[cyan]=006

# use vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr "%F{${prompt_colors[cyan]}}!"
zstyle ':vcs_info:git:*' stagedstr "%F{${prompt_colors[red]}}+"
zstyle ':vcs_info:git+set-message:*' hooks \
  git-hook-begin \
  git-untracked \
  git-unpushed
zstyle ':vcs_info:*' formats "%F{${prompt_colors[green]}}%u%c(%b)%m%f"
zstyle ':vcs_info:*' actionformats '%c%y<%a>(%b)%m%f'

# extra vcs_info hooks
function +vi-git-hook-begin () {
  if [[ "$(command git rev-parse --is-inside-work-tree 2> /dev/null)" \
      != "true" ]]; then
    return 1
  fi
  return 0
}

function +vi-git-untracked () {
  if command git status --porcelain 2> /dev/null \
      | command grep '^??' > /dev/null 2>&1; then
    hook_com[staged]="%F{${prompt_colors[yellow]}}?${hook_com[staged]}"
  fi
}

function +vi-git-unpushed () {
  local branch remote upstream pushed
  branch="$(command git symbolic-ref --short HEAD 2> /dev/null)"
  remote="$(command git config branch.$branch.remote 2> /dev/null)"
  if [[ -n "$remote" ]]; then
    upstream="$remote/$branch"
    if [[ -n "$(command git log $upstream..)" ]]; then
      hook_com[misc]+="%F{${prompt_colors[red]}}[up]"
    else
      hook_com[misc]+="%F{${prompt_colors[green]}}[up]"
    fi
  fi
}

# add hook redrawing prompt
function redraw-prompt () {
  PROMPT="$(venv-prompt)%F{${prompt_colors[green]}}%n%B@%b%U%m%u%f%B:%b%F{${prompt_colors[cyan]}}%~%f
%B%#❯%b "
  RPROMPT="${vcs_info_msg_0_}"
}

function redraw-prompt-with-vcs_info () {
  vcs_info
  redraw-prompt
}

if vcs_info 2> /dev/null; then
  add-zsh-hook precmd redraw-prompt-with-vcs_info
else
  add-zsh-hook precmd redraw-prompt
fi
