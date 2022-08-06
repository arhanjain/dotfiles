#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log

for m in $(polybar --list-monitors | cut -d":" -f1); do
  if [ $m == 'eDP-1' ]
  then
    polybar --reload NPinkScaled &
  else
    polybar --reload NPink &
  fi
done

echo "Bars launched..."


