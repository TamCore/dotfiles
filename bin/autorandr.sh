#!/bin/bash

SLEEP="1s"

CONF_RUN="sleep 2 && sh $HOME/.fehbg && killall -SIGUSR1 conky && killall -SIGUSR1 tint2"

# only LVDS1 connected
# - deconfigure HDMI1 and VGA1
# - auto-configure VGA1 and use as primary
CONF_LVDS1="--output HDMI1 --off --output VGA1 --off --output LVDS1 --auto"
CONF_LVDS1_RUN="pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo"

# only HDMI1 connected
# deconfigure VGA1 and LVDS1
# - auto-configure HDMI1 and use as primary
CONF_HDMI1="--output VGA1 --off --output LVDS1 --off --output HDMI1 --auto"
CONF_HDMI1_RUN="pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo; amixer set Master 1+"

# LVDS1 and VGA1 connected
# - deconfigure HDMI1
# - auto-configure LVDS1 and VGA1
# - set VGA1 as primary, left of LVDS1
CONF_LVDS1_VGA1="--output HDMI1 --off --output LVDS1 --auto --output VGA1 --auto --primary --left-of LVDS1"
CONF_LVDS1_VGA1_RUN="pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo"

# LVDS1 and HDMI1 connected
# - deconfigure VGA1
# - auto-configure LVDS1 and HDMI1
# - set HDMI1 as primary, left of LVDS1
CONF_LVDS1_HDMI1="--output VGA1 --off --output LVDS1 --auto --output HDMI1 --auto --primary --left-of LVDS1"
CONF_LVDS1_HDMI1_RUN="pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo; amixer set Master 1+"

CURRENT=""

while true
do
  CONFIG="CONF"
  while read line
  do
    output="${line%% connected*}"
    if [[ $output =~ LVDS* ]] && [ $( grep -c closed /proc/acpi/button/*/LID/state ) -eq 1 ]
    then
      echo "found ${output} but lid is closed.."
    else
      echo "found ${output}.."
      CONFIG="${CONFIG}_${output}"
    fi
  done < <(xrandr --current | grep ' connected')

  if [ "$CURRENT" != "$CONFIG" ]
  then
    echo "Using $CONFIG..."
    xrandr ${!CONFIG}

    run="${CONFIG}_RUN"
    eval ${!run}
    eval $CONF_RUN

    CURRENT="$CONFIG"
  else
    echo "Already using $CONFIG.."
  fi
  
  echo "Sleeping $SLEEP.."
  sleep $SLEEP
done
