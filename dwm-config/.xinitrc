#!/bin/sh


exec picom &
exec feh --bg-fill ~/my-config/background/image8.jpg &
exec dwm > ~/.dwm.log 2>&1

