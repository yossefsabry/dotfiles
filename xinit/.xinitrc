#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image8.jpg &
exec xrandr --output HDMI-1 --mode 1920x1080  --rate 60 &
exec slstatus &
exec unclutter -idle 0 & #for hide the mouse
exec dwm > ~/.dwm.log 2>&1

