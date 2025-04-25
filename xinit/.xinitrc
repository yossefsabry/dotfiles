#!/bin/sh

cd ~

# for touchbad on click
exec xinput set-prop "AlpsPS/2 ALPS DualPoint TouchPad" "libinput Tapping Enabled" 1 &

# for obs
# exec sudo modprobe v4l2loopback &

# set the keyboard layout adding arabic and englisht and disable caps and and 
#toggle between them with win+space
exec setxkbmap -layout us,ara -variant ,digits grp:win_space_toggle caps:none &
# set the sxhkd
exec sxhkd &
exec xset r rate 250 50 &
exec redshift -O 2000K &

# bspwm {{{
#exec flameshot &
#exec feh --bg-center --bg-scale ~/Pictures/1.jpg &
# exec bspwm > /var/log/.bspwm.log 2>&1  
#: }}}

# dwm {{{
# exec run_picom &
# exec feh --bg-center --bg-scale ~/Pictures/wallpaper/image-1.png &
# exec auto_bg &
# exec flameshot &
# exec slstatus &
# exec dwm > ~/.dwm.log 2>&1 
#: }}}

#:qtile {{{
exec feh --bg-center --bg-scale ~/Pictures/wallpaper/nearmoss.png &
exec flameshot &
exec auto_bg &
exec qtile start > ~/qtile.log 2>&1 
#:}}}

# :i3 {{{
# exec run_picom &
# exec feh --bg-center --bg-scale ~/Pictures/wallpaper/wallpepar.jpeg &
# exec flameshot &
# exec auto_bg &
# exec i3 > ~/.i3.log 2>&1 
# :}}}

# :hyprland {{{
# exec /usr/bin/Hyprland > /var/log/Hyprland.log 2>&1 
# :}}}

