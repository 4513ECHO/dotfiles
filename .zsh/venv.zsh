#!usr/bin/env zsh

autoload -Uz add-zsh-hook

export DEFAULT_PACKAGES="pep8:pyflakes"
export DEFAULT_PACKAGES="${DEFAULT_PACKAGES}:neovim"
export DEFAULT_PACKAGES="${DEFAULT_PACKAGES}:python-language-server:pyls-isort:pyls-black"
export VENV_DIR_NAME="venv"
export REQUESTMENT_TXT="requestments.txt"

function venv-setup ()  {
  [[ ! -d ${VENV_DIR_NAME} ]] && python3 -m venv ${VENV_DIR_NAME}
  source ${VENV_DIR_NAME}/bin/activate
  eval "pip install ${DEFAULT_PACKAGES/:/ }"
  [[ -f ${REQUESTMENT_TXT} ]] && pip install -r ${REQUESTMENT_TXT} || touch ${REQUESTMENT_TXT}
}

function venv-clean () {
  eval "pip uninstall ${DEFAULT_PACKAGES/:/ }"
  [[ -f ${REQUESTMENT_TXT} ]] && pip uninstall -r ${REQUESTMENT_TXT}
}

function auto-venv () {
  if [[ -z "${VIRTUAL_ENV}" ]]; then
    [[ -d venv ]] && source ${VENV_DIR_NAME}/bin/activate
  else
    parentdir="$(dirname "{$VIRTUAL_ENV}")"
    [[ "$PWD"/ != "${parentdir}"/* ]] && deactivate
  fi
}
add-zsh-hook chpwd auto-venv
