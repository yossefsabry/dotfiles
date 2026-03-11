#!/bin/bash
options="Toggle\nConnect\nDisconnect\nScan\nExit"
selected=$(echo -e "$options" | rofi -dmenu -i -p "Bluetooth: ")
case $selected in
    Toggle)
        if [[ $(bluetoothctl show | grep "Powered: yes") ]]; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    Connect)
        devices=$(bluetoothctl devices | awk '{print $3 " (" $2 ")" }')
        device_name=$(echo -e "$devices" | rofi -dmenu -i -p "Connect to: ")
        mac=$(echo "$device_name" | grep -oP '\(\K[^)]+')
        [[ -n "$mac" ]] && bluetoothctl connect "$mac"
        ;;
    Disconnect)
        devices=$(bluetoothctl devices Paired | awk '{print $3 " (" $2 ")" }')
        device_name=$(echo -e "$devices" | rofi -dmenu -i -p "Disconnect: ")
        mac=$(echo "$device_name" | grep -oP '\(\K[^)]+')
        [[ -n "$mac" ]] && bluetoothctl disconnect "$mac"
        ;;
esac
