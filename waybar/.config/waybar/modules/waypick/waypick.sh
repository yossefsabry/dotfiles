#!/bin/bash

# Storage locations
COLOR_FILE="$HOME/.config/waybar/modules/waypick/last_color"
HISTORY_FILE="$HOME/.config/waybar/modules/waypick/color_history"

# Create files if they don't exist
if [ ! -f "$COLOR_FILE" ]; then
    echo "#FFFFFF " > "$COLOR_FILE"
fi

if [ ! -f "$HISTORY_FILE" ]; then
    touch "$HISTORY_FILE"
fi

get_last_color() {
    cat "$COLOR_FILE"
}

add_to_history() {
    local color="$1"
    if ! grep -q "^$color$" "$HISTORY_FILE"; then
        echo "$color" | cat - "$HISTORY_FILE" > /tmp/temphistory && mv /tmp/temphistory "$HISTORY_FILE"
        head -n 10 "$HISTORY_FILE" > /tmp/temphistory && mv /tmp/temphistory "$HISTORY_FILE"
    fi
}

pick_color() {
    color=$(hyprpicker -a)

    notify-send "Color Picked" "Color $color picked" -t 3000 -a "WayPick" -u normal
    
    if [ -n "$color" ]; then
        color=$(echo "$color" | tr -d '[:space:]')
        echo "$color" > "$COLOR_FILE"
        add_to_history "$color"
    fi
}

copy_to_clipboard() {
    color=$(get_last_color)
    echo -n "$color" | wl-copy
    notify-send "Color Copied" "Color $color copied to clipboard" -t 3000 -a "WayPick" -u normal
}

output_json() {
    color=$(get_last_color)
    printf '{"text": "<span foreground=\\"%s\\">■</span> %s", "tooltip": "Click to pick a color\\nRight-click to copy to clipboard", "class": "waypick", "alt": "%s"}' "$color" "$color" "$color"
}

case "$1" in
    pick)
        pick_color
        ;;
    copy)
        copy_to_clipboard
        ;;
    *)
        output_json
        ;;
esac 
