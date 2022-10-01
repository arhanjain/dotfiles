#!/bin/bash

killall polybar

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top -c $HOME/.config/polybar/bar.ini &
    MONITOR=$m polybar --reload bottom -c $HOME/.config/polybar/bar.ini &
  done
fi
