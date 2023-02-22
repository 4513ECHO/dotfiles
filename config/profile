# shellcheck shell=dash

set -ue

# If not running interactively, don't do anything
case "$-" in
  *i*)
    SHELL="$(which zsh)"
    export SHELL
    [ -z "${ZSH_VERSION:-}" ] && exec "$SHELL" -l
    ;;
  *) return ;;
esac
