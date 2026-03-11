#!/bin/bash

# Check if animations are enabled to determine gaming mode state
HYPRLAND_ANIMATIONS=$(hyprctl getoption animations:enabled | grep "int: 1")

if [[ "$1" == "toggle" ]]; then
    if [[ -z "$HYPRLAND_ANIMATIONS" ]]; then
        # Animations are currently disabled (Gaming Mode is ON), so disable it
        hyprctl reload
        notify-send -i "input-gaming" "Gaming Mode" "Disabled: Animations and blur restored."
    else
        # Animations are currently enabled (Gaming Mode is OFF), so enable it
        hyprctl --batch "keyword animations:enabled 0; keyword decoration:drop_shadow 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1"
        notify-send -i "input-gaming" "Gaming Mode" "Enabled: Performance optimized."
    fi
    # Refresh animations status after change
    HYPRLAND_ANIMATIONS=$(hyprctl getoption animations:enabled | grep "int: 1")
fi

if [[ -z "$HYPRLAND_ANIMATIONS" ]]; then
    echo '{"text": "󰊴", "class": "enabled", "tooltip": "Gaming Mode: Enabled"}'
else
    echo '{"text": "󰊴", "class": "disabled", "tooltip": "Gaming Mode: Disabled"}'
fi
