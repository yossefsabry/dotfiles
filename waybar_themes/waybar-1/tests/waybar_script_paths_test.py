#!/usr/bin/env python3
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "config.jsonc"
LAUNCH_SCRIPT_PATH = ROOT / "launch.sh"
MIC_SCRIPT_PATH = ROOT / "scripts" / "mic.sh"
HYPRLAND_CONFIG_PATH = Path("/home/yossef/.config/hypr/hyprland.conf")


def main() -> int:
    config = json.loads(CONFIG_PATH.read_text())
    failures: list[str] = []

    found_relative_path = False
    for module_name, body in config.items():
        if not isinstance(body, dict):
            continue

        for key in ("exec", "on-click", "on-click-right"):
            value = body.get(key)
            if not isinstance(value, str):
                continue

            if "/home/yossef/.config/waybar/scripts/" in value:
                failures.append(
                    f'{module_name}.{key} hardcodes scripts path instead of using the wrapper: {value}'
                )

            if "./scripts/" in value:
                found_relative_path = True

    if not found_relative_path:
        failures.append("config.jsonc should use relative ./scripts/... commands with launch.sh")

    mic_script = MIC_SCRIPT_PATH.read_text()
    if "/home/yossef/.config/waybar/scripts/" in mic_script:
        failures.append("scripts/mic.sh hardcodes the scripts path instead of using a relative path")
    if "./scripts/" not in mic_script:
        failures.append("scripts/mic.sh should use ./scripts/voxtype.sh ensure-daemon")

    if not LAUNCH_SCRIPT_PATH.exists():
        failures.append("launch.sh is missing")
    else:
        launch_script = LAUNCH_SCRIPT_PATH.read_text()
        if "cd /home/yossef/.config/waybar" not in launch_script:
            failures.append("launch.sh must cd to /home/yossef/.config/waybar")
        if "exec waybar" not in launch_script:
            failures.append("launch.sh must exec waybar")

    hyprland_config = HYPRLAND_CONFIG_PATH.read_text()
    if "exec-once = ~/.config/waybar/launch.sh" not in hyprland_config:
        failures.append("hyprland.conf must launch Waybar via ~/.config/waybar/launch.sh")

    if failures:
        print("\n".join(failures))
        return 1

    print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
