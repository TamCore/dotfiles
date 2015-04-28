#!/bin/bash

SLEEP="1s"

CONF_RUN="sleep 2 && sh $HOME/.fehbg && killall -SIGUSR1 conky && killall -SIGUSR1 tint2"

# only LVDS1 connected
# - deconfigure everything except LVDS1 (done automatically)
# - auto-configure LVDS1 and use as primary (done automatically)
# - tell pulseaudio to use the laptop's built-in speakers
CONF_LVDS1_RUN="pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo"

# only HDMI1 connected
# - deconfigure everything except HDMI1 (done automatically)
# - auto-configure HDMI1 and use as primary (done automatically)
# - tell pulseaudio to redirect audio through hdmi
CONF_HDMI1_RUN="pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo; amixer set Master 1+"

# LVDS1 and VGA1 connected
# - deconfigure everything except LVDS1 and VGA1 (done automatically)
# - auto-configure LVDS1 and VGA1
# - set VGA1 as primary and place it to the left of LVDS1
CONF_LVDS1_VGA1="--output LVDS1 --auto --output VGA1 --auto --primary --left-of LVDS1"
CONF_LVDS1_VGA1_RUN="pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo"

# LVDS1 and HDMI1 connected
# - deconfigure everything except LVDS1 and HDMI1 (done automatically)
# - auto-configure LVDS1 and HDMI1
# - set HDMI1 as primary and place it to the left of LVDS1
CONF_LVDS1_HDMI1="--output LVDS1 --auto --output HDMI1 --auto --primary --left-of LVDS1"
CONF_LVDS1_HDMI1_RUN="pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo; amixer set Master 1+"

CURRENT=""

while true
do
  CONFIG="CONF"
  CONF_OFF=""
  DISPLAY_COUNT=0
  while read line
  do
    output="${line%% connected*}"
    if [[ $output =~ LVDS* ]] && [ $( grep -c closed /proc/acpi/button/*/LID/state ) -eq 1 ]
    then
      echo "found ${output} but lid is closed.."
      CONF_OFF="--output $output --off"
    else
      echo "found ${output}.."
      CONFIG="${CONFIG}_${output}"
      DISPLAY_COUNT=$((DISPLAY_COUNT+1))
    fi
  done < <(xrandr --current | grep ' connected')

  if [ "$CURRENT" != "$CONFIG" ]
  then
    CONF_OFF="$CONF_OFF $(xrandr --current | sed -n -r 's/(.*) disconnected(.*)/--output \1 --off/p' | xargs)"
    if [ "$DISPLAY_COUNT" = "1" ]
    then
      declare $CONFIG="--output $output --auto"
    fi

    echo "Using $CONFIG (${!CONFIG})..."
    xrandr $CONF_OFF ${!CONFIG}

    run="${CONFIG}_RUN"
    eval ${!run}
    eval $CONF_RUN

    CURRENT="$CONFIG"
  else
    echo "Already using $CONFIG.."
  fi
  
  echo "Sleeping $SLEEP.."
  echo
  sleep $SLEEP
done
