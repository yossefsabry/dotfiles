#!/bin/sh

cd ~

[ -f ~/.xprofile ] && . ~/.xprofile

# for touchbad on click
exec xinput set-prop "AlpsPS/2 ALPS DualPoint TouchPad" "libinput Tapping Enabled" 1 &

xrandr --dpi 90

# set the keyboard layout adding arabic and englisht and disable caps and and 
#toggle between them with win+space
exec setxkbmap -layout us,ara -variant ,digits grp:win_space_toggle caps:none &
# set the sxhkd
exec sxhkd &
exec xset r rate 250 50 &
exec redshift -O 2000K &
exec skey &

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
# #: }}}

#:qtile {{{
exec feh --bg-center --bg-scale ~/Pictures/wallpaper/nearmoss.png &
exec auto_bg &
exec flameshot &
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


# for pulsaudion 
# -- this next commend for first time only --
exec pactl load-module module-echo-cancel use_master_format=1 aec_method=webrtc source_name=noise_cancel_source 
exec pactl set-default-source alsa_output.pci-0000_00_1b.0.analog-stereo.echo-cancel.monitor 



# for pipewire
#exec pactl set-default-source alsa_input.pci-0000_00_1b.0.analog-stereo &
#exec pw-cli set-param 62 Props '{ params: { "port.name" = "analog-input-headset-mic" } }' &

# for obs
# exec sudo modprobe v4l2loopback &
