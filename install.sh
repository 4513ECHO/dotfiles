#!/bin/sh

DOTPATH=~/dotfiles

for f in .??*
do
  [ "$f" = ".git" ] && continue

  ln -snfv $DOTPATH/$f $HOME/$f
  echo "link $f"
done

if [ "$SHELL" != "*/zsh" ]; then
  echo "Please change shell to zsh"
fi
