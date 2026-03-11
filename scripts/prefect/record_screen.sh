#!/usr/bin/env bash

# Recording script for Hyprland using ffmpeg
# Saves to ~/Videos folder

# Check for required tools
for tool in ffmpeg hyprctl slurp jq notify-send; do
    if ! command -v "$tool" &> /dev/null; then
        echo "Error: $tool is not installed."
        exit 1
    fi
done

# Output directory
SAVE_DIR="$HOME/Videos"
mkdir -p "$SAVE_DIR"

# File name with timestamp
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="${SAVE_DIR}/recording_${TIMESTAMP}.mp4"

# Select recording area
# Options: 
# 1. Selected window (using hyprctl)
# 2. Workspace (using slurp and hyprctl)
# 3. Selected region (using slurp)
# 4. Entire monitor

echo "Choose recording type:"
echo "1. Window"
echo "2. Workspace"
echo "3. Selection"
echo "4. Monitor"

read -p "Enter choice [1-4]: " CHOICE

case "$CHOICE" in
    1)
        # Record a specific window
        WINDOW_INFO=$(hyprctl clients -j | jq -r '.[] | "\(.title) | \(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        SELECTED=$(echo "$WINDOW_INFO" | fzf --prompt="Select window: ")
        if [ -z "$SELECTED" ]; then
            echo "No window selected. Exiting."
            exit 1
        fi
        GEOM=$(echo "$SELECTED" | cut -d'|' -f2 | xargs)
        ;;
    2)
        # Record a specific workspace
        WORKSPACE_INFO=$(hyprctl workspaces -j | jq -r '.[] | "Workspace \(.id) on monitor \(.monitor)"')
        SELECTED=$(echo "$WORKSPACE_INFO" | fzf --prompt="Select workspace: ")
        if [ -z "$SELECTED" ]; then
            echo "No workspace selected. Exiting."
            exit 1
        fi
        MONITOR=$(echo "$SELECTED" | awk '{print $NF}')
        GEOM=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | \"\(.x),\(.y) \(.width)x\(.height)\"")
        ;;
    3)
        # Record a selected region
        GEOM=$(slurp)
        ;;
    4)
        # Record a specific monitor
        MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[] | "\(.name) | \(.width)x\(.height) at \(.x),\(.y)"')
        SELECTED=$(echo "$MONITOR_INFO" | fzf --prompt="Select monitor: ")
        if [ -z "$SELECTED" ]; then
            echo "No monitor selected. Exiting."
            exit 1
        fi
        NAME=$(echo "$SELECTED" | cut -d'|' -f1 | xargs)
        GEOM=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$NAME\") | \"\(.x),\(.y) \(.width)x\(.height)\"")
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

if [ -z "$GEOM" ]; then
    echo "No area selected. Exiting."
    exit 1
fi

# Parse geometry
# slurp returns: X,Y WxH
X=$(echo "$GEOM" | cut -d',' -f1)
Y=$(echo "$GEOM" | cut -d',' -f2 | cut -d' ' -f1)
W=$(echo "$GEOM" | cut -d' ' -f2 | cut -dx -f1)
H=$(echo "$GEOM" | cut -d' ' -f2 | cut -dx -f2)

# Ensure dimensions are even for x264
W=$(( (W / 2) * 2 ))
H=$(( (H / 2) * 2 ))

# Notify start
notify-send "Recording started" "Saving to ${FILENAME}\nPress q or Ctrl+C in terminal to stop." -t 3000

# Audio recording (optional, using pulse monitor)
# Get default sink monitor
SINK_MONITOR=$(pactl get-default-sink).monitor

# Cleanup on exit
cleanup() {
    echo -e "\nStopping recording..."
    # Killing ffmpeg gracefully
    pkill -SIGINT -P $$
    wait
    notify-send "Recording stopped" "Saved to ${FILENAME}" -t 3000
    exit 0
}

trap cleanup SIGINT SIGTERM

# FFmpeg command
...
echo "Recording ${W}x${H} at ${X},${Y}..."
echo "Press 'q' or Ctrl+C to stop recording."

# Using kmsgrab with libx264
ffmpeg -y \
    -f kmsgrab \
    -i - \
    -f pulse \
    -i "$SINK_MONITOR" \
    -vf "hwdownload,format=bgr0,crop=${W}:${H}:${X}:${Y},format=yuv420p" \
    -c:v libx264 \
    -preset ultrafast \
    -crf 23 \
    -c:a aac \
    -b:a 128k \
    "$FILENAME"

# If we reach here, ffmpeg finished normally
cleanup
