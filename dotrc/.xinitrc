#!/bin/sh
# shellcheck source=/dev/null

has() { command -v "$1" > /dev/null; }

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Run ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] && has ssh-agent; then
  exec ssh-agent "$0" "$@" || exit
fi

# Prepare D-Bus
if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
  dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
elif has dbus-run-session; then
  exec dbus-run-session "$0" "$@" || exit
elif has dbus-launch; then
  exec dbus-launch --exit-with-session "$0" "$@" || exit
fi

# define variables for GUI
# IME settings
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
has chromium-browser && export BROWSER=chromium-browser-wrapper
# has wezterm && export TERMINAL=wezterm
[ -n "$LOADED_ZSHRC" ] && unset LOADED_ZSHRC

fcitx-autostart &
# xremap "$XDG_CONFIG_HOME"/xremap/config.yml &
xkbcomp -I"$XDG_CONFIG_HOME"/X11/xkb "$XDG_CONFIG_HOME"/X11/xkb/keymap/mine "$DISPLAY"

# load system configuration
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -f "$f" ] && . "$f"
  done
  unset f
fi
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# start desktop
exec i3
