#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ ! -z "$(xrandr | grep '^HDMI1 connected')" ] && \
    xrandr --output LVDS1 --auto --output HDMI1 --auto --primary --left-of LVDS1

[ -f /usr/bin/xbindkeys ]  && xbindkeys &
[ -f /usr/bin/xbacklight ] && xbacklight -set 70 &
[ -f /usr/bin/setxkbmap ]  && setxkbmap de -variant nodeadkeys &
[ -f /usr/bin/compton ]    && compton -b &
[ -f /usr/bin/numlockx ]   && numlockx on &

export XDG_CACHE_HOME=/tmp/philipp.cache
export XDG_MENU_PREFIX="lxde-"

exec openbox-session
