#!/usr/bin/env bash
set -euo pipefail

WRAPPER="${WRAPPER:-/home/yossef/.config/waybar/scripts/voxtype.sh}"
TEST_NAME=""

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local message="$3"

  if [[ "$expected" != "$actual" ]]; then
    printf 'FAIL: %s\nexpected: %s\nactual:   %s\n' "$message" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_contains_line() {
  local needle="$1"
  local haystack="$2"
  local message="$3"

  if ! grep -Fqx "$needle" <<<"$haystack"; then
    printf 'FAIL: %s\nmissing line: %s\nfull output:\n%s\n' "$message" "$needle" "$haystack" >&2
    exit 1
  fi
}

wait_for_line() {
  local needle="$1"
  local file="$2"

  for _ in $(seq 1 20); do
    if grep -Fqx "$needle" "$file" 2>/dev/null; then
      return 0
    fi
    sleep 0.05
  done

  return 1
}

make_fake_bin() {
  local dir="$1"

  mkdir -p "$dir"

  cat >"$dir/pgrep" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'pgrep:%s\n' "$*" >>"${TEST_LOG}"
exit "${PGREP_EXIT:-1}"
EOF

  cat >"$dir/nohup" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'nohup:%s\n' "$*" >>"${TEST_LOG}"
"$@"
EOF

  cat >"$dir/voxtype" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'voxtype:%s\n' "$*" >>"${TEST_LOG}"
if [[ "${1:-}" == "status" ]]; then
  counter_file="${TEST_STATUS_COUNTER_FILE:-}"
  if [[ -n "$counter_file" ]]; then
    count=0
    if [[ -f "$counter_file" ]]; then
      count="$(cat "$counter_file")"
    fi
    count=$((count + 1))
    printf '%s' "$count" >"$counter_file"
    ready_after="${TEST_STATUS_READY_AFTER:-1}"
    if (( count < ready_after )); then
      printf '{"text":"","alt":"stopped","class":"stopped","tooltip":"Voxtype not running"}\n'
      exit 0
    fi
  fi
  printf '{"text":"","alt":"idle","class":"idle","tooltip":"Voxtype ready"}\n'
  exit 0
fi
if [[ "${1:-}" == "record" && "${2:-}" == "toggle" && -n "${TEST_STATUS_COUNTER_FILE:-}" ]]; then
  count=0
  if [[ -f "$TEST_STATUS_COUNTER_FILE" ]]; then
    count="$(cat "$TEST_STATUS_COUNTER_FILE")"
  fi
  ready_after="${TEST_STATUS_READY_AFTER:-1}"
  if (( count < ready_after )); then
    printf 'daemon not ready\n' >&2
    exit 1
  fi
fi
exit 0
EOF

  chmod +x "$dir/pgrep" "$dir/nohup" "$dir/voxtype"
}

run_wrapper() {
  local tempdir="$1"
  shift

  TEST_LOG="$tempdir/log"
  export TEST_LOG
  TEST_STATUS_COUNTER_FILE="$tempdir/status-counter"
  export TEST_STATUS_COUNTER_FILE
  : >"$TEST_LOG"
  : >"$TEST_STATUS_COUNTER_FILE"

  PATH="$tempdir/bin:$PATH" HOME="$tempdir/home" "$WRAPPER" "$@"
}

test_bootstraps_daemon_before_toggling_recording() {
  TEST_NAME="test_bootstraps_daemon_before_toggling_recording"
  local tempdir
  tempdir="$(mktemp -d)"
  make_fake_bin "$tempdir/bin"

  PGREP_EXIT=1 run_wrapper "$tempdir" toggle

  local actual
  wait_for_line 'voxtype:daemon' "$tempdir/log" || true
  actual="$(cat "$tempdir/log")"
  local first_line
  first_line="$(head -n 1 "$tempdir/log")"
  assert_eq 'pgrep:-fa (^|/)voxtype( daemon)?$' "$first_line" "$TEST_NAME"
  assert_contains_line 'nohup:voxtype daemon' "$actual" "$TEST_NAME"
  assert_contains_line 'voxtype:daemon' "$actual" "$TEST_NAME"
  assert_contains_line 'voxtype:record toggle' "$actual" "$TEST_NAME"
  rm -rf "$tempdir"
}

test_waits_for_daemon_readiness_before_toggling() {
  TEST_NAME="test_waits_for_daemon_readiness_before_toggling"
  local tempdir
  tempdir="$(mktemp -d)"
  make_fake_bin "$tempdir/bin"

  TEST_STATUS_READY_AFTER=3 PGREP_EXIT=1 run_wrapper "$tempdir" toggle

  local actual
  wait_for_line 'voxtype:status --format json' "$tempdir/log" || true
  actual="$(cat "$tempdir/log")"
  assert_contains_line 'voxtype:status --format json' "$actual" "$TEST_NAME"
  assert_contains_line 'voxtype:record toggle' "$actual" "$TEST_NAME"
  rm -rf "$tempdir"
}

test_toggle_invokes_voxtype_record_toggle() {
  TEST_NAME="test_toggle_invokes_voxtype_record_toggle"
  local tempdir
  tempdir="$(mktemp -d)"
  make_fake_bin "$tempdir/bin"

  PGREP_EXIT=0 run_wrapper "$tempdir" toggle

  local actual
  actual="$(cat "$tempdir/log")"
  assert_eq $'pgrep:-fa (^|/)voxtype( daemon)?$\nvoxtype:status --format json\nvoxtype:record toggle' "$actual" "$TEST_NAME"
  rm -rf "$tempdir"
}

test_ensure_daemon_is_noop_when_daemon_is_running() {
  TEST_NAME="test_ensure_daemon_is_noop_when_daemon_is_running"
  local tempdir
  tempdir="$(mktemp -d)"
  make_fake_bin "$tempdir/bin"

  PGREP_EXIT=0 run_wrapper "$tempdir" ensure-daemon

  local actual
  actual="$(cat "$tempdir/log")"
  assert_eq $'pgrep:-fa (^|/)voxtype( daemon)?$' "$actual" "$TEST_NAME"
  rm -rf "$tempdir"
}

main() {
  test_bootstraps_daemon_before_toggling_recording
  test_waits_for_daemon_readiness_before_toggling
  test_toggle_invokes_voxtype_record_toggle
  test_ensure_daemon_is_noop_when_daemon_is_running
  printf 'PASS\n'
}

main "$@"
