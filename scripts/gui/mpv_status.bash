#!/usr/bin/env bash

SOCKET="/tmp/mpv-socket"
MAXLEN=40

shorten() {
    local text="$1"
    local max="$2"
    local len
    len=$(printf "%s" "$text" | wc -m)

    if [ "$len" -gt "$max" ]; then
        printf "%s…" "$(printf "%s" "$text" | cut -c1-"$((max-1))")"
    else
        printf "%s" "$text"
    fi
}

mpv_get() {
    local prop="$1"
    printf '{ "command": ["get_property", "%s"] }\n' "$prop" \
        | socat - "$SOCKET" 2>/dev/null \
        | jq -r '.data // empty' 2>/dev/null
}

fallback_title_from_path() {
    local p="$1"
    p="${p##*/}"
    p="${p%.*}"
    printf "%s" "$p"
}

case "$BLOCK_BUTTON" in
    1)
        [ -S "$SOCKET" ] && printf '{ "command": ["cycle", "pause"] }\n' | socat - "$SOCKET" >/dev/null 2>&1
        ;;
esac

if [ ! -S "$SOCKET" ]; then
    echo "MPV: off"
    exit 0
fi

title="$(mpv_get media-title)"
pause_state="$(mpv_get pause)"
path_value="$(mpv_get path)"

if [ -z "$title" ] || [ "$title" = "null" ]; then
    title="$(fallback_title_from_path "$path_value")"
fi

if [ -z "$title" ]; then
    title="running"
fi

title="$(shorten "$title" "$MAXLEN")"

if [ "$pause_state" = "true" ]; then
    echo "MPV: [pause] $title"
else
    echo "MPV: $title"
fi
