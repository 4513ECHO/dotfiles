#!usr/bin/env zsh

autoload -Uz add-zsh-hook

DEFAULT_PACKAGES="neovim pep8 pyflakes python-language-server pyls-isort pyls-black"

function venv-setup ()  {
  [[ ! -d "venv" ]] && python3 -m venv venv
  source venv/bin/activate
  eval "pip install ${DEFAULT_PACKAGES}"
  [[ -f "requestments.txt" ]] && pip install -r requestment.txt
}

function auto-venv () {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    [[ -d venv ]] && source venv/bin/activate
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    [[ "$PWD"/ != "${parentdir}"/* ]] && deactivate
  fi
}
add-zsh-hook chpwd auto-venv
