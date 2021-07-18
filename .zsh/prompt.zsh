#!usr/bin/env zsh

autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=${terminfo[cud1]}${terminfo[cuu1]}${terminfo[sc]}${terminfo[cud1]}
function left_down_prompt_preexec () {
  print -rn -- ${terminfo[el]}
}
add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish () {
  local mode
  case $KEYMAP in
    main|viins)
    mode="${fg[cyan]}-- INSERT --${reset_color}"
    ;;
  vicmd)
    mode="${fg[white]}-- NORMAL --${reset_color}"
    ;;
  esac

  MODE="%{${terminfo_down_sc}${mode}${terminfo[rc]}%}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

function git-prompt () {
  local branchname branch st remote pushed upstream
  branchname=`git symbolic-ref --short HEAD 2> /dev/null`
  if [ -z ${branchname} ]; then
    return
  fi
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"`  ]]; then
    branch="%{${fg[green]}%}($branchname)%{${reset_color}%}"
  elif [[ -n `echo "$st" | grep "^nothing added"`  ]]; then
    branch="%{${fg[yellow]}%}($branchname)%{${reset_color}%}"
  else
    branch="%{${fg[red]}%}($branchname)%{${reset_color}%}"
  fi

  remote=`git config branch.${branchname}.remote 2> /dev/null`
  if [ -z ${remote}  ]; then
    pushed=''
  else
    upstream="${remote}/${branchname}"
    if [[ -z `git log ${upstream}..${branchname}`  ]]; then
      pushed="%{${fg[green]}%}[up]%{${reset_color}%}"
    else
      pushed="%{${fg[red]}%}[up]%{${reset_color}%}"
    fi
  fi

  echo "${branch}${pushed}"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
function venv-prompt () {
  if [ -n "${VIRTUAL_ENV}" ]; then
    echo "(`basename \"${VIRTUAL_ENV}\"`)"
  else
    echo ''
  fi
}

function precmd () {
  PROMPT="${MODE}`venv-prompt`%{${fg[green]}%}%n@%m%{${reset_color}%}:%{${fg[blue]}%}%~%{${reset_color}%}%# "
  RPROMPT="`git-prompt`"
}

