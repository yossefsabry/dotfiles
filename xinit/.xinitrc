#!/bin/sh

cd ~

# for touchbad on click
exec xinput set-prop "AlpsPS/2 ALPS DualPoint TouchPad" "libinput Tapping Enabled" 1 &

# set the keyboard layout adding arabic and englisht and disable caps and and 
#toggle between them with win+space
exec setxkbmap -layout us,ara -variant ,digits grp:win_space_toggle caps:none &
# set the sxhkd
exec sxhkd &
exec feh --bg-center --bg-scale ~/Pictures/1.jpg &
exec xset r rate 250 50 &
exec picom &

# bspwm {{{
# exec bspwm > /var/log/.bspwm.log 2>&1  
#: }}}

# dwm {{{
exec slstatus &
exec dwm > ~/.dwm.log 2>&1 
: }}}

#:qtile {{{
# exec qtile start > /var/log/qtile.log 2>&1 
#:}}}

# :i3 {{{
# exec i3 > /var/log/.i3.log 2>&1 
# :}}}

# :hyprland {{{
# exec /usr/bin/Hyprland > /var/log/Hyprland.log 2>&1 
# :}}}
