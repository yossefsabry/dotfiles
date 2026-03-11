#!/bin/bash
options="performance\nbalanced\npower-saver"
selected=$(echo -e "$options" | rofi -dmenu -i -p "Power Profile: ")
if [[ -n "$selected" ]]; then
    powerprofilesctl set "$selected"
fi
