#!/bin/sh
set -ue
if [ -n "${GIT_EDITOR:-}" ]; then
  $GIT_EDITOR "$@"
  exit $?
fi
if [ -n "$NVIM" ] || [ -n "$VIM_TERMINAL" ]; then
  $EDITOR "$@"
elif command -v nvim > /dev/null; then
  nvim "$@"
else
  vim "$@"
fi
