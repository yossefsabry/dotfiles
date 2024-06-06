#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image2.jpg &
exec slstatus &
exec dwm > ~/.dwm.log 2>&1

