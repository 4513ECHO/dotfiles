
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias dev="cd ~/Develops"
alias dot="cd ~/dotfiles"

if type exa > /dev/null; then
  alias ls="exa -a"
  alias exa="exa -a"
  alias tree="exa --tree --group-directories-first --git-ignore --ignore-glob .git"
else
  alias ls="ls -a --color=auto"
  alias tree="tree -I '\.git|venv|node_modules'"
fi

alias c="clear"
alias g="git"
alias globalip="curl -q globalip.me"
alias grep="grep --color=auto"
alias herokulogin="heroku login --interactive"
alias reload="source $ZDOTDIR/.zshrc"
alias rm="rm -i"
alias mkdir="mkdir -p"
# alias pytree="tree -aI 'venv|__pycache__|\.git'"
# alias python="${commands[python]:-"python3"}"
alias q=" exit"

# fzf shortcut
alias -g Ga='$(git status -s | fzf --multi --preview '"'"'git diff --color=always {2}'"'"' | awk '"'"'{print $2}'"'"')'
alias -g D='~/Develops/$(ls -A  ~/Develops | fzf)'

