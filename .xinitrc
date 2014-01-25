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
[ -f /usr/bin/compton ]    && compton -b &
[ -f /usr/bin/numlockx ]   && numlockx on &

export LC_ALL=de_DE.UTF-8
export LANG=de_DE.UTF-8
export XDG_CACHE_HOME=/tmp/philipp.cache

exec openbox-session
