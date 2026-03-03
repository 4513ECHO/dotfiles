#!/bin/bash
set -ue -o pipefail
GITHUB_TOKEN=$(gh auth token)
export GITHUB_TOKEN
rm -fv ~/.cache/nvim/dpp/*/*.vim
rm -fv ~/.cache/nvim/dpp/runtimepath_cache
vim -es -i NONE -Nu ~/.vimrc +'set verbose=1' || :
echo
nvim --headless || :
echo
