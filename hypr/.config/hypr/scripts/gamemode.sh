#!/bin/bash

HYPR_STATE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPR_STATE" = 1 ]; then
    # Disable eye candy for gaming
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:rounding 0;\
        keyword decoration:drop_shadow 0;\
        keyword misc:vrr 1;\
        keyword render:direct_scanout 1"
    notify-send -u low "Gaming Mode" "Performance optimized. Animations and blur disabled."
else
    # Re-enable eye candy
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:blur:enabled 1;\
        keyword decoration:rounding 2;\
        keyword decoration:drop_shadow 1;\
        keyword misc:vrr 2;\
        keyword render:direct_scanout 0"
    notify-send -u low "Gaming Mode" "Eye candy restored."
fi
