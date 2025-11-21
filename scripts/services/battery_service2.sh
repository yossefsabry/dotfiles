#!/bin/sh
# You could place this script in e.g. ${HOME}/scripts/alert-battery.sh

threshold=15  # threshold percentage to trigger alert
AUDIO_FILE="$HOME/Audio/low_battery.mp3"

# Use `awk` to extract battery status and capacity
acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
    read -r status capacity

    # If battery is discharging and below threshold
    if [ "${status}" = Discharging ] && [ "${capacity}" -lt "${threshold}" ]; then
        # Send notification with current percentage
        notify-send -t 300000 "⚠️ Charge your battery! (${capacity}%)"

        # Play sound in background (silent errors, non-blocking)
        if [ -f "$AUDIO_FILE" ]; then
            killall paplay
            nohup paplay "$AUDIO_FILE" >/dev/null 2>&1 &
        fi
    fi
}

