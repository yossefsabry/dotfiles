#!/bin/bash

choice=$(printf "⏻  Shutdown\n  Reboot\n󰍃  Suspend\n󰌾  Lock" | \
    rofi -dmenu -p "Power" \
    -theme-str 'element-text { font: "JetBrainsMono Nerd Font 16"; }
                listview { lines: 4; }
                element { padding: 14px; }
                window { width: 24%; }')

case "$choice" in
    *Shutdown*) systemctl poweroff ;;
    *Reboot*) systemctl reboot ;;
    *Suspend*) hyprctl dispatch exit ;;
    *Lock*) hyprlock ;;
esac
