#!/bin/bash

choice=$(printf "⏻  Shutdown\n  Reboot\n󰍃  Suspend\n󰌾  Lock" | \
    rofi -dmenu -p "Power" \
    -theme-str 'element-text { font: "JetBrainsMono Nerd Font 16"; }
                listview { lines: 4; }
                element { padding: 14px; }
                window { width: 24%; }')

case "$choice" in
    *Shutdown*) 
        notify-send -t 2000 "System" "Shutting down..."
        systemctl poweroff 
        ;;
    *Reboot*) 
        notify-send -t 2000 "System" "Rebooting..."
        systemctl reboot 
        ;;
    *Suspend*) 
        notify-send -t 2000 "System" "Suspending..."
        hyprctl dispatch exit 
        ;;
    *Lock*) 
        notify-send -t 2000 "System" "Locking screen..."
        hyprlock 
        ;;
esac

