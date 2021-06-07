#!/bin/bash

DOTPATH=~/.dotfiles

for f in .??*
do
  [ "$f" = ".git"] && continue

  ln -snfv "DOTPATH/$f" "$HOME"/"$f"
done
