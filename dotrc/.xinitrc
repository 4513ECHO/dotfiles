#!/bin/sh
# shellcheck source=/dev/null

# IME settings
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

# define variables for GUI
command -v chromium > /dev/null && export BROWSER=chromium
[ -n "$LOADED_ZSHRC" ] && unset LOADED_ZSHRC

# load system configuration
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -f "$f" ] && . "$f"
  done
  unset f
fi
[ -f /etc/X11/Xsession ] && . /etc/X11/Xsession

# start desktop
exec i3
