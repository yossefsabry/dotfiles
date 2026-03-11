#!/bin/bash
options="Toggle WiFi\nConnect to SSID\nStatus\nExit"
selected=$(echo -e "$options" | rofi -dmenu -i -p "Network: ")
case $selected in
    "Toggle WiFi")
        if [[ $(nmcli radio wifi) == "enabled" ]]; then
            nmcli radio wifi off
        else
            nmcli radio wifi on
        fi
        ;;
    "Connect to SSID")
        ssids=$(nmcli device wifi list | tail -n +2 | awk '{print $2}')
        ssid=$(echo -e "$ssids" | rofi -dmenu -i -p "Connect to: ")
        if [[ -n "$ssid" ]]; then
            nmcli device wifi connect "$ssid"
        fi
        ;;
    "Status")
        nmcli device status | rofi -dmenu -i -p "Status: "
        ;;
esac
