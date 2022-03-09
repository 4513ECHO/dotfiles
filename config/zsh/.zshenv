# zmodload zsh/zprof && zprof

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export VIMINIT="source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export DENO_INSTALL="$XDG_CACHE_HOME/deno"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

typeset -Ux path fpath manpath cdpath
path=(
  $CARGO_HOME/bin(N-/)
  $GOPATH/bin(N-/)
  $DENO_INSTALL/bin(N-/)
  $HOME/.deno/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/bin(N-/)
  $path
)
path=(${(R)path%/})
fpath=(
  $ZDOTDIR/completions(N-/)
  $fpath
)
fpath=(${(R)fpath%/})

export CARGO_NET_GIT_FETCH_WITH_CLI=true

export EDITOR="vim"
export PAGER="less"
export BROWSER="w3m"
export MANPAGER="vim -M +MANPAGER -"
export LESS="-g -i -M -R -W -z-4 -x4"
export LESSCHARSET="UTF-8"

export LANG="ja_JP.UTF-8"
export LC_TIME="en_US.UTF-8"
export TZ="Asia/Tokyo"

export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

