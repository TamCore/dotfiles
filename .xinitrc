#!/bin/sh

[ -f /usr/bin/xbindkeys ]  && xbindkeys &
[ -f /usr/bin/xbacklight ] && xbacklight -set 70 &
[ -f /usr/bin/xcompmgr ]   && xcompmgr &

exec openbox-session
