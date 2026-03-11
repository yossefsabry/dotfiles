#!/bin/bash

# Simple bluetooth menu using rofi and bluetoothctl

# Get current status
status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$status" = "yes" ]; then
    toggle="󰂲  Disable Bluetooth"
else
    toggle="󰂯  Enable Bluetooth"
fi

# Get list of devices (connected/paired)
devices=$(bluetoothctl devices | awk '{$1=""; print $0}' | sed 's/^ //')

choice=$(printf "$toggle\n$devices" | rofi -dmenu -p "Bluetooth" -theme-str 'window { width: 25%; } listview { lines: 8; }')

if [ -z "$choice" ]; then
    exit
fi

if [ "$choice" = "$toggle" ]; then
    if [ "$status" = "yes" ]; then
        bluetoothctl power off
        notify-send -t 2000 "Bluetooth" "Bluetooth Disabled"
    else
        bluetoothctl power on
        notify-send -t 2000 "Bluetooth" "Bluetooth Enabled"
    fi
else
    # Find device MAC address
    mac=$(bluetoothctl devices | grep "$choice" | awk '{print $2}')
    if [ -n "$mac" ]; then
        notify-send -t 2000 "Bluetooth" "Connecting to $choice..."
        bluetoothctl connect "$mac"
    fi
fi
