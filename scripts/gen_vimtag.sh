#!/bin/sh
# based on https://github.com/kuuote/dotvim/commit/4e3e801c
set -ue
export LANG=C
cd "$(git rev-parse --show-toplevel)/config/nvim"
rg --vimgrep --glob 'dein/*.toml' '^repo = ' \
  | perl -pe "s|([^:]+).+?(repo = '.+?([^/']+)')|join(\"\t\",\$3,\$1,'?^'.\$2)|e" \
  | sort > /tmp/tags
if ! diff -u tags /tmp/tags; then
  echo copy
  cp /tmp/tags tags
fi
