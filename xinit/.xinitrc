#!/bin/sh


exec picom &
exec feh --bg-center --bg-scale   ~/dotfiles/background/image2.jpg &
# exec xrandr --output HDMI-1 --mode 1920x1080  --rate 60 &
exec slstatus &
exec unclutter -idle 0 & #for hide the mouse
exec dwm > ~/.dwm.log 2>&1
#exec syncthing & # for start syncthing

