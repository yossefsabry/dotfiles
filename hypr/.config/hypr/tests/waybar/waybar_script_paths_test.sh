#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${CONFIG_PATH:-/home/yossef/.config/waybar/config.jsonc}"
SCRIPTS_DIR="${SCRIPTS_DIR:-/home/yossef/.config/waybar/scripts}"

python - <<'PY'
import json
import os
import sys
from pathlib import Path

config_path = Path(os.environ["CONFIG_PATH"])
scripts_dir = os.environ["SCRIPTS_DIR"]
config = json.loads(config_path.read_text())

failures = []

def check_module(name, body):
    if not isinstance(body, dict):
        return

    if name == "custom/voxtype":
        if body.get("exec") != f"{scripts_dir}/voxtype_status.sh":
            failures.append(f'{name}.exec must be {scripts_dir}/voxtype_status.sh')

    if name == "custom/idle-indicator":
        if body.get("exec") != f"{scripts_dir}/idle_indicator.sh":
            failures.append(f'{name}.exec must be {scripts_dir}/idle_indicator.sh')

    if name == "custom/notification-silencing-indicator":
        if body.get("exec") != f"{scripts_dir}/notification_silencing.sh":
            failures.append(f'{name}.exec must be {scripts_dir}/notification_silencing.sh')

    if name == "custom/screenrecording-indicator":
        if body.get("exec") != f"{scripts_dir}/screen_recording.sh":
            failures.append(f'{name}.exec must be {scripts_dir}/screen_recording.sh')

for key, value in config.items():
    check_module(key, value)

if failures:
    print("\n".join(failures))
    sys.exit(1)

print("PASS")
PY
