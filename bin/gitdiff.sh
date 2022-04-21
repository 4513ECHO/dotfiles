#!/bin/sh

set -eu

if [ -n "${GITDIFF:-}" ]; then
  "$GITDIFF" "$@"
  exit $?
fi
if command -v delta > /dev/null 2>&1; then
  delta "$@"
elif command -v diff-highlight > /dev/null 2>&1; then
  diff-highlight "$@"
elif [ -x /usr/share/doc/git/contrib/diff-highlight/diff-highlight ]; then
  /usr/share/doc/git/contrib/diff-highlight/diff-highlight "$@"
elif [ -x /usr/share/git/diff-highlight/diff-highlight ]; then
  /usr/share/git/diff-highlight/diff-highlight "$@"
else
  diff "$@"
fi
