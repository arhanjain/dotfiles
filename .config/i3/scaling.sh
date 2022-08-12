xrandr --dpi 192

if [ $(xrandr | grep -sw 'connected' | wc -l) -gt 1 ]; then
  xrandr --output DP-1 --scale 1.3x1.3 --mode 3840x1600 --pos 0x0 \
  --output eDP-1 --mode 2736x1824 --pos 4992x0
fi
