HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

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

export EDITOR="vim"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls="ls -a --color=auto"

alias dev="cd ~/Develops"
alias dot="cd ~/dotfiles"

alias c="clear"
alias g="git"
alias herokulogin="heroku login --interactive"
alias reload="source ~/.bashrc"
alias rm="rm -i"
alias q="exit"
