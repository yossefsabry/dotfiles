#!/usr/bin/env bash
set -euo pipefail

status_json() {
  voxtype status --format json 2>/dev/null || true
}

daemon_ready() {
  local status
  status="$(status_json)"

  [[ "$status" == *'"class":"idle"'* ]] || \
  [[ "$status" == *'"class": "idle"'* ]] || \
  [[ "$status" == *'"class":"recording"'* ]] || \
  [[ "$status" == *'"class": "recording"'* ]] || \
  [[ "$status" == *'"class":"transcribing"'* ]] || \
  [[ "$status" == *'"class": "transcribing"'* ]]
}

wait_for_daemon_ready() {
  local attempt
  for attempt in $(seq 1 40); do
    if daemon_ready; then
      return 0
    fi
    sleep 0.05
  done

  printf 'voxtype daemon did not become ready in time\n' >&2
  return 1
}

ensure_daemon() {
  if pgrep -fa '(^|/)voxtype( daemon)?$' >/dev/null; then
    return 0
  fi

  nohup voxtype daemon >/dev/null 2>&1 &
  wait_for_daemon_ready
}

toggle_recording() {
  ensure_daemon
  wait_for_daemon_ready
  voxtype record toggle
}

main() {
  local command="${1:-toggle}"

  case "$command" in
    ensure-daemon)
      ensure_daemon
      ;;
    toggle)
      toggle_recording
      ;;
    *)
      printf 'usage: %s [ensure-daemon|toggle]\n' "$0" >&2
      exit 1
      ;;
  esac
}

main "$@"
