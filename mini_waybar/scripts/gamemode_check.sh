#!/bin/bash

# Check if animations are enabled
HYPR_STATE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPR_STATE" = "0" ]; then
    # Gaming mode is ON (animations are disabled)
    echo '{"text": "GAMING: ON", "class": "on", "tooltip": "Gaming Mode is ON"}'
else
    # Gaming mode is OFF (animations are enabled)
    echo '{"text": "GAMING: OFF", "class": "off", "tooltip": "Gaming Mode is OFF"}'
fi
