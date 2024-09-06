#!/bin/sh

cd ~

# set the keyboard layout adding arabic and englisht and disable caps and and 
#toggle between them with win+space
exec setxkbmap -layout us,ara -variant ,digits grp:win_space_toggle caps:none &
# set the sxhkd
exec sxhkd &
exec unclutter -idle 0 & # for hide the mouse
exec feh --bg-center --bg-scale ~/dotfiles/background/image4.jpg &
exec flameshot &
exec xset r rate 190 50 &
exec picom &

# bspwm {{{
# exec bspwm > ~/.bspwm.log 2>&1  
#: }}}

# dwm {{{
exec slstatus &
exec dwm > ~/.dwm.log 2>&1 
#: }}}

#:qtile {{{
# exec qtile start > ~/.qtile.log 2>&1 
#:}}}

# :i3 {{{
# exec i3 > ~/.i3.log 2>&1 
# :}}}

# :hyprland {{{
# exec /usr/bin/Hyprland > ~/.Hyprland.log 2>&1 
# :}}}
