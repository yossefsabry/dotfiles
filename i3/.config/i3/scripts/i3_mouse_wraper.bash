#!/bin/bash
# Listens for window focus changes and moves mouse to center
i3-msg -t subscribe -m '[ "window" ]' | while read -r line; do
    # Get the ID of the currently focused window
    window_id=$(xdotool getwindowfocus)
    
    # Move mouse to the center of that window
    if [ ! -z "$window_id" ]; then
        xdotool mousemove --window "$window_id" --polar 0 0
    fi
done
