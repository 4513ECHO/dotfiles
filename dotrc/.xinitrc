#!/bin/sh

# IME settings
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# define variables for GUI
type chromium-browser 2> /dev/null && export BROWER=chromium-browser
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

# load system configuration
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# start desktop
exec i3
