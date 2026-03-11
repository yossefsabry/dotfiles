#!/bin/bash

STATE_FILE="/tmp/waybar_gamemode"

if [[ "$1" == "toggle" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
        hyprctl reload
        notify-send -i "input-gaming" "Gaming Mode" "Disabled: Animations and blur restored."
    else
        touch "$STATE_FILE"
        hyprctl --batch "keyword animations:enabled 0; keyword decoration:drop_shadow 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1"
        notify-send -i "input-gaming" "Gaming Mode" "Enabled: Performance optimized."
    fi
fi

if [[ -f "$STATE_FILE" ]]; then
    echo '{"text": "󰊴", "class": "enabled", "tooltip": "Gaming Mode: Enabled"}'
else
    echo '{"text": "󰊴", "class": "disabled", "tooltip": "Gaming Mode: Disabled"}'
fi
