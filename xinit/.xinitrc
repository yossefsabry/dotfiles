#!/bin/sh

# set the keyboard layout adding arabic and englisht and disable caps and and 
#toggle between them with win+space
exec setxkbmap -layout us,ara -variant ,digits grp:win_space_toggle caps:none &

# set the sxhkd
exec sxhkd &

exec picom &
exec feh --bg-center --bg-scale   ~/dotfiles/background/image2.jpg &
# exec xrandr --output HDMI-1 --mode 1920x1080  --rate 60 &
exec slstatus &
exec unclutter -idle 0 & #for hide the mouse
exec dwm > ~/.dwm.log 2>&1


