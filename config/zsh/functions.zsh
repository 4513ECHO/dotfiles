#!/usr/bin/env zsh
#
autoload -Uz add-zsh-hook

VENV_DIR_NAME="venv"
SSH_KEY="id_git_rsa"

auto-venv () {
  if [[ -z "${VIRTUAL_ENV}" ]]; then
    if [[ -f "${VENV_DIR_NAME}/bin/activate" ]]; then
      source "${VENV_DIR_NAME}/bin/activate"
    fi
  else
    parentdir="$(dirname "{$VIRTUAL_ENV}")"
    if [[ "$PWD"/ != "${parentdir}"/* ]]; then
      deactivate
      if [[ -f "${VENV_DIR_NAME}/bin/activate" ]]; then
        source "${VENV_DIR_NAME}/bin/activate"
      fi
    fi
  fi
}
add-zsh-hook chpwd auto-venv

enable-port-forward () {
  if [[ -z $SSH_AUTH_HOCK ]]; then
    eval $(ssh-agent) > /dev/null
  fi
  ssh-add $HOME/.ssh/$SSH_KEY
}

[[ -f $HOME/.ssh/$SSH_KEY ]] && [[ -f $HOME/.ssh/config ]] && enable-port-forward

colortable () {
  for c in {000..255}; do
    printf  "\033[38;5;${c}m $c\033[m"
    [[ $(($c%16)) -eq 15 ]] && echo
  done
  echo
}

colortable-rich () {
  printcolor () {
    printf "\033[48;5;%dm\033[38;5;251m%9d \033[m" $1 $1
  }
  for r in {0..4}; do
    for b in {0..5}; do
      printcolor $(($r*36+5*6+$b+16))
    done
    echo
  done
  for g in {0..5}; do
    for b in {0..5}; do
      printcolor $((5*36+30-$g*6+$b+16))
    done
    for r in {1..5}; do
      printcolor $((180-$r*36+30-$g*6+5+16))
    done
    echo
  done
}
