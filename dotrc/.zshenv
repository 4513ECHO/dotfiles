export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export VIMINIT='source $XDG_CONFIG_HOME/vim/vimrc'
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export DOTPATH="$HOME/dotfiles"

export LOCALPATH="$HOME/.local/bin"
export POERTYPATH="$HOME/.poetry/bin"
export DOTPATH="$HOME/dotfiles"
export DENO_INSTALL="$XDG_CACHE_HOME/deno"
export PATH="$DENO_INSTALL/bin:$CARGO_HOME/bin:$POERTYPATH:$LOCALPATH:$PATH"

export EDITOR="vim"
export PAGER="less"
export LESS="-g -i -M -R -W -z-4 -x4"
export LESSCHARSET="UTF-8"

export LANG="ja_JP.UTF-8"
export LC_TIME="en_US.UTF-8"

export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=1000000
export SAVEHIST=1000000

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
