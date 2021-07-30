#!usr/bin/env zsh

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias ls="ls -a --color=always"
alias grep="grep --color=always"

alias dev="cd ~/Develops"
alias dot="cd ~/dotfiles"

alias vimconf="$EDITOR $ZDOTDIR/.vimrc"
alias zshconf="$EDITOR $ZDOTDIR/.zshrc"

alias c="clear"
alias g="git"
alias globalip="curl globalip.me"
alias herokulogin="heroku login --interactive"
alias reload="exec $SHEll -l; [[ $- =~ i ]] && source $ZDOTDIR/.zshrc"
alias rm="rm -i"
alias q="exit"
