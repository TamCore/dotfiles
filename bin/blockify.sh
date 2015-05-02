#!/bin/bash
while true
do
  if pgrep spotify &>/dev/null
  then
    if ! pgrep blockify &>/dev/null
    then
      pacmd set-sink-input-mute $(pacmd list-sink-inputs | grep -B15 '<spotify>' | sed -n -r 's/index: ([0-9]{,5})/\1/gp') 0
      blockify &
    fi
  else
    if pgrep blockify &>/dev/null
    then
      killall -9 blockify
    fi
  fi
  sleep 1
done
