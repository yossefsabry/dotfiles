#!/bin/sh


exec picom &
exec feh --bg-fill ~/dotfiles/background/image6.jpg &
exec dwm > ~/.dwm.log 2>&1

