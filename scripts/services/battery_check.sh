#!/bin/bash

# Battery path may vary; usually BAT0 or BAT1
BATTERY_PATH="/sys/class/power_supply/BAT0/capacity"
BATTERY_STATUS_PATH="/sys/class/power_supply/BAT0/status"
AUDIO_FILE="$HOME/Audio/low_battery.mp3"

if [ ! -f "$BATTERY_PATH" ]; then
  echo "Battery path not found."
  exit 1
fi

level=$(cat "$BATTERY_PATH")
status=$(cat "$BATTERY_STATUS_PATH")

# Function to send notification and play sound
notify_with_sound() {
    local urgency=$1
    local title=$2
    local message=$3

    notify-send -u "$urgency" "$title" "$message" && \
        paplay --volume=30000 /home/yossef/Audio/low-battery-charge-421814.mp3
    
}

# Only notify if not charging or full
if [[ "$status" != "Charging" && "$status" != "Full" ]]; then
    if (( level < 5 )); then
        notify_with_sound "critical" "Battery Critical" "Battery level is below 5%!"
    elif (( level < 10 )); then
        notify_with_sound "critical" "Battery Low" "Battery level is below 10%."
    elif (( level < 15 )); then
        notify_with_sound "normal" "Battery Warning" "Battery level is below 15%."
    elif (( level < 50 )); then
        notify_with_sound "low" "Battery Notice" "Battery level is below 20%."
    fi
fi

