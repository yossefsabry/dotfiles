import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "config.jsonc"


def load_config() -> dict:
    return json.loads(CONFIG_PATH.read_text())


def test_workspace_module_shows_numbered_icons_without_persistent_slots() -> None:
    workspace = load_config()["hyprland/workspaces"]

    assert workspace["format"] == "{id}: {icon}"
    assert "persistent-workspaces" not in workspace
    assert workspace["format-icons"]["default"] == "○"
    assert workspace["format-icons"]["focused"] == "●"
