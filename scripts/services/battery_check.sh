#!/bin/bash

# Battery path may vary; usually BAT0 or BAT1
BATTERY_PATH="/sys/class/power_supply/BAT0/capacity"
BATTERY_STATUS_PATH="/sys/class/power_supply/BAT0/status"

if [ ! -f "$BATTERY_PATH" ]; then
  echo "Battery path not found."
  exit 1
fi

level=$(cat "$BATTERY_PATH")
status=$(cat "$BATTERY_STATUS_PATH")

# Only notify if not charging or full
if [[ "$status" != "Charging" && "$status" != "Full" ]]; then
    if (( level < 5 )); then
        notify-send -u critical "Battery Critical" "Battery level is below 5%!"
    elif (( level < 10 )); then
        notify-send -u critical "Battery Low" "Battery level is below 10%."
    elif (( level < 15 )); then
        notify-send -u normal "Battery Warning" "Battery level is below 15%."
    elif (( level < 20 )); then
        notify-send -u low "Battery Notice" "Battery level is below 20%."
    fi
fi

