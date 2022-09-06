#!/bin/bash

polybar-msg cmd quit

polybar top -c $HOME/.config/polybar/bar.ini & disown
polybar bottom -c $HOME/.config/polybar/bar.ini & disown

