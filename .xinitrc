#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image1.jpg &
exec dwm > ~/.dwm.log 2>&1

