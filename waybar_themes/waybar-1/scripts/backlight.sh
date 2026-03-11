#!/bin/bash
options="5%\n10%\n20%\n30%\n40%\n50%\n60%\n70%\n80%\n90%\n100%"
selected=$(echo -e "$options" | rofi -dmenu -i -p "Brightness: ")
if [[ -n "$selected" ]]; then
    brightnessctl set "$selected"
fi
