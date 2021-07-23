#!/usr/bin/env bash

for rc in .??*
do
  [[ "$rc" = ".git" ]] && continue
  [[ "$rc" = ".gitignore" ]] && continue

  ln -snfv "$DOTPATH/$rc" "$HOME/$rc"
done

[[ ! "$SHELL" =~ "zsh$" ]] && chsh -s /usr/bin/zsh

