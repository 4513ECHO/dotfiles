#!/bin/sh

abort () {
  printf '\033[31;1m [ERROR]\033[m %s\n' "$1"
  exit 1
}

warning () {
  printf '\033[33;1m [WARNING]\033[m %s\n' "$1"
}

info () {
  printf '\033[36;1m [INFO]\033[m %s\n' "$1"
}

confirm () {
  while :; do
    printf '\033[32;1m [QUESTION]\033[m %s [y/n]: ' "$1"
    read -r confirm_answer
    case "$confirm_answer" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) warning "Please answer yes or no" ;;
    esac
  done
}

arch="$(uname -m)"
os="$(uname -o)"

info "Your architecture is $arch"
info "Your OS is $os"

case "$os" in
  *[lL]inux*) echo linux ;;
  *) abort "Unknown OS" ;;
esac

info "Make XDG base directories"
mkdir -pv ~/.config
mkdir -pv ~/.local/bin
mkdir -pv ~/.local/share
mkdir -pv ~/.cache

if [ -z "$MINIMUM_DOTFILES" ]; then
  if confirm "Your dotfiles is not minimum now. Do you want to set dotfiles minimum?"; then
    info "Set your dotfiles minimum"
    export MINIMUM_DOTFILES=true
  fi
fi

info "Installing deno for '${DENO_INSTALL:-$HOME/.deno}' ..."
if [ "$arch" = "x86_64" ]; then
  :
  # curl -fsSL 'https://deno.land/x/install/install.sh' | sh
elif [ "$arch" = "aarch64" ]; then
  :
  # curl -fsSL 'https://noxifoxi.github.io/deno_install-arm64/install.sh' | sh
fi

info "Installing rust for \
  '${CARGO_HOME:-$HOME/.cargo}' and '${RUSTUP_HOME:-$HOME/.rustup}' ..."
# curl -fsSL 'https://sh.rustup.rs/' | sh -s -- -y

info "Installing aqua for"
# curl -fsSL 'https://raw.githubusercontent.com/aquaproj/aqua-installer/v0.3.0/aqua-installer' | bash -s -- -i ~/.local/bin


info "Installing node.js"
# curl https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${os}-${arch}.tar.xz | tar Jxvf -


