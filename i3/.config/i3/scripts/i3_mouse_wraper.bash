#!/usr/bin/env bash
set -u

# Move pointer to the center of the currently focused window.
move_to_focused_window() {
    local window_id
    window_id="$(xdotool getwindowfocus 2>/dev/null || true)"
    [ -n "${window_id}" ] || return 0
    xdotool mousemove --window "${window_id}" --polar 0 0 >/dev/null 2>&1 || true
}

# Initial sync in case i3 starts with an already-focused container.
move_to_focused_window

# Subscribe to window events and only react to focus changes.
i3-msg -t subscribe -m '[ "window" ]' | while IFS= read -r line; do
    case "${line}" in
        *'"change":"focus"'*)
            move_to_focused_window
            ;;
    esac
done
