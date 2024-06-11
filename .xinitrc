#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image2.jpg &

exec slstatus &
exec unclutter -idle 0 & #for hide the mouse

# exec dwmstatus 2>&1 >/dev/null &

exec dwm > ~/.dwm.log 2>&1

