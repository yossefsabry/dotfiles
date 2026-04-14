#!/bin/sh

MAXLEN=18

shorten() {
    text="$1"
    max="$2"
    len=$(printf "%s" "$text" | wc -m)

    if [ "$len" -gt "$max" ]; then
        printf "%s…" "$(printf "%s" "$text" | cut -c1-"$((max-1))")"
    else
        printf "%s" "$text"
    fi
}

case "$BLOCK_BUTTON" in
    1)
        mpc toggle >/dev/null 2>&1
        ;;
esac

if pgrep -x mpd >/dev/null; then
    state="$(mpc status 2>/dev/null | awk 'NR==2 {print $1}')"
    song="$(mpc current 2>/dev/null)"

    [ -z "$song" ] && song="no song"
    song="$(shorten "$song" "$MAXLEN")"

    case "$state" in
        "[playing]")
            echo "MPD: $song"
            ;;
        "[paused]")
            echo "MPD:[pause] $song"
            ;;
        *)
            echo "MPD:stopped"
            ;;
    esac
else
    echo "MPD: off"
fi
