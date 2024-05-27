#!/bin/sh


exec picom &
exec feh --bg-fill Picture/wallpaperflare.com_wallpaper.jpg &
exec dwm > ~/.dwm.log 2>&1

