#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f /usr/bin/xbindkeys ]  && xbindkeys &
[ -f /usr/bin/xbacklight ] && xbacklight -set 70 &
[ -f /usr/bin/setxkbmap ]  && setxkbmap de -variant nodeadkeys &
[ -f /usr/bin/compton ]    && compton -CG --paint-on-overlay --backend xrender --vsync opengl -b &
[ -f /usr/bin/numlockx ]   && numlockx on &
[ -f /usr/bin/xscreensaver ] && xscreensaver -no-splash &

export XDG_CACHE_HOME=/tmp/$USER.cache
export XDG_MENU_PREFIX="lxde-"
export VDPAU_DRIVER=va_gl
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

exec openbox-session
