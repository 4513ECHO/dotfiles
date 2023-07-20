#!/bin/sh
set -ue
if [ -n "${GIT_EDITOR:-}" ]; then
  $GIT_EDITOR "$@"
  exit $?
fi
if [ -n "$NVIM" ]; then
  nvim -R -n --headless "$@"
elif [ -n "$VIM_TERMINAL" ]; then
  vim -R -N -n -X -e -s "$@"
elif command -v nvim > /dev/null; then
  nvim "$@"
elif command -v vim > /dev/null; then
  vim "$@"
else
  exit 1
fi
