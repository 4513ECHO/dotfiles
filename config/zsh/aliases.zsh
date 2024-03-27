alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

alias dot='cd ~/dotfiles'

if command -v eza > /dev/null; then
  alias ls='eza -a'
  alias ll='eza -al'
  alias eza='eza -a'
  alias tree='eza --tree --group-directories-first --git-ignore --ignore-glob .git'
else
  alias ls='ls -a --color=auto'
  alias ll='ls -l'
  alias tree="tree -I '\.git|venv|node_modules|__pycache__'"
fi
if command -v rg > /dev/null; then
  alias grep='rg'
else
  alias grep='grep --color=auto'
  alias rg='grep --color=auto'
fi

alias a='aqua'
alias d='docker'
alias g='git'
alias sys='systemctl --user'
alias brwe='brew'
alias carog='cargo' # for typo
alias globalip='curl -q globalip.me'
alias reload='exec $SHELL -l && rehash'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias q=' exit'
