# zmodload zsh/zprof && zprof
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
[[ $(uname) == 'Linux' ]] && export XDG_RUNTIME_DIR="/run/user/$UID"

## zsh ##
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

## docker ##
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"

## go ##
export GOPATH="$XDG_DATA_HOME/go"

## deno ##
export DENO_INSTALL="$XDG_CACHE_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL"

## rust ##
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_NET_GIT_FETCH_WITH_CLI=true

## aqua ##
export AQUA_GLOBAL_CONFIG="$XDG_CONFIG_HOME/aqua/aqua.yaml"
export AQUA_ROOT_DIR="$XDG_DATA_HOME/aquaproj-aqua"
# export AQUA_POLICY_CONFIG="$XDG_CONFIG_HOME/aqua/aqua-policy.yaml"
export AQUA_DISABLE_POLICY=true

## afx ##
export AFX_COMMAND_PATH="$HOME/.local/share/afx/bin"

## python ##
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

## ripgrep ##
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

## wget ##
# export WGETRC="$XDG_CONFIG_HOME/wgetrc"

## npm ##
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"

## less ##
export LESS='--hilite-search --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --window=4 --tabs=4 --mouse'
export LESSCHARSET='UTF-8'

typeset -Ux path fpath manpath cdpath
path=(
  $CARGO_HOME/bin(N-/)
  $GOPATH/bin(N-/)
  $DENO_INSTALL/bin(N-/)
  $HOME/.local/bin(N-/)
  $AQUA_ROOT_DIR/bin(N-/)
  $AFX_COMMAND_PATH(N-/)
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  $path[@]
)
path=(${(R)path%/})
fpath=(
  $ZDOTDIR/completions(N-/)
  $fpath[@]
)
fpath=(${(R)fpath%/})

typeset -ax EDITOR=(${(Q@s: :)EDITOR:-$(command -v nvim > /dev/null && echo nvim || echo vim)})
export PAGER='less'
export MANPAGER='less +Gg'

export LANG='ja_JP.UTF-8'
export LC_TIME='en_US.UTF-8'
export TZ='Asia/Tokyo'
