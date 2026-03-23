#!/bin/bash
# Simple Rofi Power Menu
chosen=$(echo -e "Lock\nSuspend\nReboot\nShutdown\nHibernate" | rofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    Lock) hyprlock ;;
    Suspend) systemctl suspend ;;
    Reboot) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
    Hibernate) systemctl hibernate ;;
esac
