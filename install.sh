#!/bin/sh

DOTPATH=~/dotfiles

for f in .??*
do
  [ "$f" = ".git" ] && continue

  ln -snfv $DOTPATH/$f $HOME/$f
  echo "link $f"
done

if [ "$SHELL" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
  echo "Please reboot"
fi
