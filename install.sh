#!/bin/sh

DOTPATH=~/dotfiles

for f in .??*
do
  [ "$f" = ".git" ] && continue

  ln -snfv $DOTPATH/$f $HOME/$f
done

<<<<<<< HEAD

if [ "$SHELL" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
  echo "Please reboot"
=======
if [ "$SHELL" != "*/zsh" ]; then
  echo "Please change shell to zsh"
>>>>>>> a578e4ff1e5b162eb45ba007d56d61651a190b23
fi
