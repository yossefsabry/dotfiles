#!/usr/bin/env python3
# qtile music toggle script
# supports: brave, mpv, mpc/mpd, spotify, vlc, and more
# usage: import in qtile config.py and bind to a key

import subprocess
from libqtile import qtile
from typing import Any, Optional

class MusicController:
    """Handles music player detection and control."""
    
    @staticmethod
    def is_running(process_name: str) -> bool:
        """Check if a process is running."""
        try:
            result = subprocess.run(
                ["pgrep", "-fi", process_name],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True
            )
            return bool(result.stdout.strip())
        except subprocess.SubprocessError:
            return False

    @staticmethod
    def send_dbus_command(service: str, command: str) -> bool:
        """Send DBus command to media player."""
        try:
            subprocess.run(
                [
                    "dbus-send",
                    "--print-reply",
                    f"--dest=org.mpris.MediaPlayer2.{service}",
                    "/org/mpris/MediaPlayer2",
                    f"org.mpris.MediaPlayer2.Player.{command}"
                ],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            return True
        except subprocess.SubprocessError:
            return False

    @staticmethod
    def send_xdotool_to_window(window_class: str, key: str) -> bool:
        """Send keypress to specific window."""
        try:
            subprocess.run(
                ["xdotool", "search", "--class", window_class, "windowfocus", "key", key],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            return True
        except subprocess.SubprocessError:
            return False

    @classmethod
    def toggle_player(cls, player: str) -> bool:
        """Attempt to toggle specific player."""
        commands = {
            "brave": [
                lambda: cls.send_dbus_command("brave", "PlayPause"),
                lambda: cls.send_xdotool_to_window("brave", "space")
            ],
            "spotify": [lambda: cls.send_dbus_command("spotify", "PlayPause")],
            "vlc": [lambda: cls.send_dbus_command("vlc", "PlayPause")],
            "mpv": [lambda: subprocess.run(["playerctl", "-p", "mpv", "play-pause"], check=True)],
            "mpd": [lambda: subprocess.run(["mpc", "toggle"], check=True)],
            "playerctl": [lambda: subprocess.run(["playerctl", "play-pause"], check=True)]
        }

        if player not in commands:
            return False

        for cmd in commands[player]:
            try:
                if cmd():
                    return True
            except subprocess.SubprocessError:
                continue
        return False

def toggle_music(qtile: Optional[Any] = None) -> None:
    """Main function to toggle music playback."""
    controller = MusicController()
    players = ["brave", "spotify", "vlc", "mpv", "mpd", "playerctl"]
    
    for player in players:
        if controller.is_running(player):
            if controller.toggle_player(player):
                if qtile:
                    qtile.notify("Music control", f"Toggled playback for {player}")
                return
    
    # If we get here, no player was successfully controlled
    if qtile:
        qtile.notify("Music control failed", "No supported player found or control failed")
    else:
        print("Error: No supported music player found or control failed")

# example usage in qtile config.py:
# from music_toggle import toggle_music
# Key([], "XF86AudioPlay", lazy.function(toggle_music)),
# Key(["mod4"], "m", lazy.function(toggle_music)),
