
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias ls="ls -a --color=auto"
alias grep="grep --color=auto"

alias dev="cd ~/Develops"
alias dot="cd ~/dotfiles"

alias c="clear"
alias g="git"
alias globalip="curl -q globalip.me"
alias herokulogin="heroku login --interactive"
alias reload="source $ZDOTDIR/.zshrc"
alias rm="rm -i"
alias pytree="tree -aI 'venv|__pycache__|\.git'"
alias python="${commands[python]:-"python3"}"
alias q="exit"

# fzf shortcut
alias -g Gd='$(tree $(git root) -afidI .git | fzf)'
alias -g Ga='$(git status -s | fzf | awk '"'"'{print $2}'"'"')'
alias -g Gf='$(git ls-files | fzf)'
alias -g Gr='$(git root)'
alias -g D='~/Develops/$(ls -A  ~/Develops | fzf)'
