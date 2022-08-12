xrandr --dpi 192

if [ xrandr | grep -sw 'connected' | wc -l > 1 ]; then
  xrandr --output DP-1 --primary --scale 1.25x1.25 --mode 3840x1600 --pos 0x0 \
  --output eDP-1 --mode 2736x1824 --pos 4800x0
fi
