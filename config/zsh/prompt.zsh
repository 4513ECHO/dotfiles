git-prompt () {
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
venv-prompt () {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "($(basename "$VIRTUAL_ENV"))"
  else
    echo ''
  fi
}

redraw-prompt () {
  PROMPT="$(venv-prompt)%F{070}%n@%m%f:%F{075}%~%f%# "
  RPROMPT="$(git-prompt)"
}
add-zsh-hook precmd redraw-prompt
