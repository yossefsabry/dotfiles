# ~/.config/qtile/music_widget.py
from libqtile import widget, bar, hook
from libqtile.command.base import expose_command
from libqtile.widget import base
import subprocess
from typing import Optional

class MusicControls(base._Widget):
    """Custom widget for music control with song info"""
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("play_icon", "▶", "Play icon"),
        ("pause_icon", "⏸", "Pause icon"),
        ("next_icon", "⏭", "Next icon"),
        ("prev_icon", "⏮", "Previous icon"),
        ("max_length", 30, "Maximum song info length"),
        ("update_interval", 1, "Update interval in seconds"),
    ]

    def __init__(self, **config):
        super().__init__(length=bar.STRETCH, **config)
        self.add_defaults(MusicControls.defaults)
        self.add_callbacks({
            "Button1": self.toggle_playback,
            "Button2": self.next_track,
            "Button3": self.prev_track,
        })
        self.current_status = "stopped"
        self.current_song = ""
        self._setup_hooks()
    def _setup_hooks(self):
        """Setup hooks for player changes"""
        @hook.subscribe.client_managed
        @hook.subscribe.client_unmanaged
        def _(*args):
            self.update()

    def _get_song_info(self) -> str:
        """Get current song info using playerctl"""
        try:
            artist = subprocess.check_output(
                ["playerctl", "metadata", "artist"],
                stderr=subprocess.DEVNULL,
                text=True
            ).strip()
            
            title = subprocess.check_output(
                ["playerctl", "metadata", "title"],
                stderr=subprocess.DEVNULL,
                text=True
            ).strip()

            if artist and title:
                return f"{artist} - {title}"
            elif title:
                return title
            else:
                return "No song playing"
        except:
            return "No player active"

    def _get_playback_status(self) -> str:
        """Get current playback status"""
        try:
            return subprocess.check_output(
                ["playerctl", "status"],
                stderr=subprocess.DEVNULL,
                text=True
            ).strip().lower()
        except:
            return "stopped"

    def update(self):
        """Update widget content"""
        self.current_status = self._get_playback_status()
        self.current_song = self._get_song_info()
        self.draw()

    def draw(self):
        """Draw widget content"""
        # Shorten song info if too long
        display_text = self.current_song
        if len(display_text) > self.max_length:
            display_text = display_text[:self.max_length-3] + "..."

        # Set icons based on status
        status_icon = self.pause_icon if self.current_status == "playing" else self.play_icon

        # Create the widget content
        content = f"{self.prev_icon} {status_icon} {self.next_icon} {display_text}"
        
        # Create a TextLayout for the widget
        layout = self.drawer.textlayout(
            content,
            self.foreground,
            self.font,
            self.fontsize,
            self.fontshadow,
            markup=True
        )
        
        # Draw the layout
        self.drawer.clear(self.background or self.bar.background)
        layout.draw(0, 0)
        self.drawer.draw(offsetx=self.offset, offsety=self.offsety, width=self.length)

    @expose_command()
    def toggle_playback(self):
        """Toggle play/pause"""
        subprocess.run(["playerctl", "play-pause"])
        self.update()

    @expose_command()
    def next_track(self):
        """Skip to next track"""
        subprocess.run(["playerctl", "next"])
        self.update()

    @expose_command()
    def prev_track(self):
        """Skip to previous track"""
        subprocess.run(["playerctl", "previous"])
        self.update()

    def timer_setup(self):
        """Setup update timer"""
        self.timeout_add(self.update_interval, self.update)

    def setup_hooks(self):
        """Setup hooks for player changes"""
        def update_on_change(*args, **kwargs):
            self.update()

        self.hook_subscribe.client_managed(update_on_change)
        self.hook_subscribe.client_unmanaged(update_on_change)
