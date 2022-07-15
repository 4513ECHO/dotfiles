# zmodload zsh/zprof && zprof

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_DATA_HOME/zsh/history"

## docker ##
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

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
export AQUA_CONFIG="$XDG_CONFIG_HOME/aqua/aqua.yaml"
export AQUA_ROOT_DIR="$XDG_DATA_HOME/aquaproj-aqua"

## python ##
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

## ripgrep ##
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

## wget ##
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

## npm ##
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"

## less ##
export LESS='--hilite-search --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --window=4 --tabs=4'
export LESSCHARSET='UTF-8'
export LESS_TERMCAP_mb=$'\e[1;38;5;139m' # Begins blinking
export LESS_TERMCAP_md=$'\e[1;38;5;110m' # Begins bold
export LESS_TERMCAP_me=$'\e[0m'          # Ends mode
export LESS_TERMCAP_so=$'\e[48;5;243m'   # Begins standout-mode
export LESS_TERMCAP_se=$'\e[0m'          # Ends standout-mode
export LESS_TERMCAP_us=$'\e[4;38;5;143m' # Begins underline
export LESS_TERMCAP_ue=$'\e[0m'          # Ends underline

typeset -Ux path fpath manpath cdpath
path=(
  $CARGO_HOME/bin(N-/)
  $GOPATH/bin(N-/)
  $DENO_INSTALL/bin(N-/)
  $HOME/.deno/bin(N-/)
  $HOME/.local/bin(N-/)
  $AQUA_ROOT_DIR/bin(N-/)
  $HOME/bin(N-/)
  $path
)
path=(${(R)path%/})
fpath=(
  $ZDOTDIR/completions(N-/)
  $fpath
)
fpath=(${(R)fpath%/})

export EDITOR='nvim'
export PAGER='less'
export BROWSER='w3m'
# export MANPAGER='vim -M +MANPAGER -'
export MANPAGER='less +Gg'

export LANG='ja_JP.UTF-8'
export LC_TIME='en_US.UTF-8'
export TZ='Asia/Tokyo'

export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

