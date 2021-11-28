autoload -Uz vcs_info || NO_VSC_INFO=true
setopt prompt_subst

export VIRTUAL_ENV_DISABLE_PROMPT=1
venv-prompt () {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "($(basename "$VIRTUAL_ENV"))"
  else
    echo ''
  fi
}

# use term ansi prompt_colors when using vim
typeset -gA prompt_colors
if [[ -n "$VIM" ]]; then
  prompt_colors[red]=001
  prompt_colors[green]=002
  prompt_colors[yellow]=003
  prompt_colors[cyan]=006
else
  prompt_colors[red]=161
  prompt_colors[green]=070
  prompt_colors[yellow]=228
  prompt_colors[cyan]=075
fi

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
    # hook_com[staged]+="%F{${prompt_colors[yellow]}}?"
    hook_com[staged]="%F{${prompt_colors[yellow]}}?${hook_com[staged]}"
  fi
}

function +vi-git-unpushed () {
  local branch remote upstream pushed
  branch="$(command git symbolic-ref --short HEAD 2> /dev/null)"
  remote="$(command git config branch.${branch}.remote 2> /dev/null)"
  if [[ -n "$remote" ]]; then
    upstream="$remote/$branch"
    if [[ -n `git log ${upstream}..${branchname}`  ]]; then
      hook_com[misc]+="%F{${prompt_colors[red]}}[up]"
    else
      hook_com[misc]+="%F{${prompt_colors[green]}}[up]"
    fi
  fi
}

# add hook redrawing prompt
function redraw-prompt () {
  PROMPT="$(venv-prompt)%F{${prompt_colors[green]}}%n@%m%f:%F{${prompt_colors[cyan]}}%~%f%# "
  RPROMPT="${vcs_info_msg_0_}"
}

function redp-with-vsc_info () {
  vcs_info
  redraw-prompt
}

if [[ -z "$NO_VSC_INFO" ]]; then
  add-zsh-hook precmd redp-with-vcs_info
else
  add-zsh-hook precmd redraw-prompt
fi
