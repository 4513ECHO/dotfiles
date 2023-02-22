#!/bin/sh
set -ue

TYPE=''
case $1 in
  link) TYPE='link' ;;
  unlink) TYPE='unlink' ;;
  debug) TYPE='debug' ;;
esac

root="$(git rev-parse --show-toplevel)"

expand_env() {
  eval echo "$*"
}
__link() {
  [ -L "$2" ] && rm -f "$2"
  [ -d "$(dirname "$2")" ] || mkdir -vp "$(dirname "$2")"
  ln -sf "$1" "$2" && printf '\e[38;5;141;1mLink\e[m %s \e[1m->\e[m %s...\n' "$2" "$1"
}
__rm() {
  rm -f "$1" && printf '\e[1;38;5;213mDelete\e[m %s...\n' "$1"
}

# shellcheck disable=SC2002
cat ./manifest.tsv | while read -r target link; do
  link="$(expand_env "$link")"
  case "$TYPE" in
    debug) echo __link "$root/config/$target" "$link" ;;
    link) __link "$root/config/$target" "$link" ;;
    unlink) __rm "$link/$target" ;;
  esac
done
for bin in "$root"/bin/*; do
  case "$TYPE" in
    debug) echo __link "$bin" ~/.local/bin ;;
    link) __link "$bin" ~/.local/bin ;;
    unlink) __rm ~/.local/bin/"$(basename "$bin")" ;;
  esac
done
case "$TYPE" in
  debug) echo __link "$root/config/zsh/.zshenv" "$HOME" ;;
  link) __link "$root/config/zsh/.zshenv" "$HOME" ;;
  unlink) __rm ~/.zshenv ;;
esac
