#!/bin/sh
# You could place this script in e.g. ${HOME}/scripts/alert-battery.sh

threshold=15  # threshold percentage to trigger alert

# Use `awk` to extract battery status and capacity
acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
  read -r status capacity

  # If battery is discharging and below threshold
  if [ "${status}" = Discharging ] && [ "${capacity}" -lt "${threshold}" ]; then
    # Send notification with current percentage
    notify-send -t 300000 "⚠️ Charge your battery! (${capacity}%)"
  fi
}

