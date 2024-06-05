#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image4.jpg &
exec slstatus &
exec dwm > ~/.dwm.log 2>&1

