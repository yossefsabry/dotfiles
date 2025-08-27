
import subprocess

def battery_warning(battery_widget):
    """Check battery level and send notifications."""
    percent = battery_widget.percent  # 0.0 → 1.0
    state = battery_widget.status     # 'Charging', 'Discharging', 'Full', etc.

    if state == "Discharging":
        if percent <= 0.1:  # 10%
            subprocess.run([
                "notify-send", "-u", "critical",
                "⚠️ Battery Low",
                f"Battery is at {int(percent*100)}%. Please plug in your charger!"
            ])
        elif percent <= 0.2:  # 20%
            subprocess.run([
                "notify-send", "-u", "normal",
                "🔋 Battery Warning",
                f"Battery is at {int(percent*100)}%."
            ])
