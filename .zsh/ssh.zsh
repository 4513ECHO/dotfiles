#!/usr/bin/env zsh

SSH_KEY=id_git_rsa

[[ ! -f $HOME/.ssh/$SSH_KEY ]] && return

function enable-post-forward () {
  if [[ -z $SSH_AUTH_HOCK ]]; then
    eval $(ssh-agent) > /dev/null
  fi
  ssh-add $HOME/.ssh/$SSH_KEY
}

enable-post-forward

