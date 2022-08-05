alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

alias dot='cd ~/dotfiles'

if command -v exa > /dev/null; then
  alias ls='exa -a'
  alias ll='exa -al'
  alias exa='exa -a'
  alias tree='exa --tree --group-directories-first --git-ignore --ignore-glob .git'
else
  alias ls='ls -a --color=auto'
  alias ll='ls -l'
  alias tree="tree -I '\.git|venv|node_modules|__pycache__'"
fi
if command -v rg > /dev/null; then
  alias grep='rg'
else
  alias grep='grep --color=auto'
fi

alias a='aqua'
alias d='docker'
alias g='git'
alias sys='systemctl'
alias carog='cargo' # for typo
alias globalip='curl -q globalip.me'
alias reload='exec $SHELL -l'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias q=' exit'
