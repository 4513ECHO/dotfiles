
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias dot="cd ~/dotfiles"

if type exa > /dev/null; then
  alias ls="exa -a"
  alias exa="exa -a"
  alias tree="exa --tree --group-directories-first --git-ignore --ignore-glob .git"
else
  alias ls="ls -a --color=auto"
  alias tree="tree -I '\.git|venv|node_modules|__pycache__'"
fi

alias c="clear"
alias g="git"
alias globalip="curl -q globalip.me"
alias grep="grep --color=auto"
alias reload="source $ZDOTDIR/.zshrc"
alias rm="rm -i"
alias mkdir="mkdir -p"
alias q=" exit"

