#!/bin/bash
options="Status\nEnergy Saver\nBalanced\nPerformance"
selected=$(echo -e "$options" | rofi -dmenu -i -p "Battery/Power: ")
case $selected in
    Status) upower -i $(upower -e | grep 'BAT') | rofi -dmenu -i -p "Battery Info: " ;;
    "Energy Saver") powerprofilesctl set power-saver ;;
    Balanced) powerprofilesctl set balanced ;;
    Performance) powerprofilesctl set performance ;;
esac
