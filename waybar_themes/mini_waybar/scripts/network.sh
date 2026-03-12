#!/bin/bash

# Simple network menu using rofi and nmcli
# Lists available wifi networks and shows status

# Get current status
status=$(nmcli -t -f WIFI g)

if [ "$status" = "enabled" ]; then
    toggle="󰖪  Disable WiFi"
else
    toggle="󰖩  Enable WiFi"
fi

# Get list of networks
networks=$(nmcli -t -f SSID dev wifi | grep -v '^--$' | sort -u)

choice=$(printf "$toggle\n$networks" | rofi -dmenu -p "Network" -theme-str 'window { width: 25%; } listview { lines: 10; }')

if [ -z "$choice" ]; then
    exit
fi

if [ "$choice" = "$toggle" ]; then
    if [ "$status" = "enabled" ]; then
        nmcli radio wifi off
        notify-send -t 2000 "Network" "WiFi Disabled"
    else
        nmcli radio wifi on
        notify-send -t 2000 "Network" "WiFi Enabled"
    fi
else
    notify-send -t 2000 "Network" "Connecting to $choice..."
    nmcli dev wifi connect "$choice"
fi
