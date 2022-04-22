# shellcheck shell=bash

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export EDITOR='nvim'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls="ls -a --color=auto"
alias dot="cd ~/dotfiles"
alias c="clear"
alias g="git"
alias reload="source ~/.bashrc"
alias rm="rm -i"
alias q="exit"
