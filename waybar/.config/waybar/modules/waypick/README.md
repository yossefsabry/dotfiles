# WayPick

A sleek color picker module for Waybar on Hyprland, inspired by Sip on macOS.

![WayPick Screenshot](screenshot.png)

## Features

- 🎨 Pick colors with hyprpicker
- 📋 Copy colors to clipboard with a right-click
- 🔄 Automatically updates when a new color is picked
- 📚 Maintains a history of recently picked colors
- 🎯 Shows the current color with a colored square icon

## Dependencies

- **hyprpicker** - For color picking
- **wl-copy** - For clipboard functionality
- **libnotify** (notify-send) - For notifications

## Installation

1. Clone this repository to your preferred location:

```bash
git clone git@github.com:OlivierDijkstra/waypick.git
```

2. Create the modules directory in your waybar config (if it doesn't exist):

```bash
mkdir -p ~/.config/waybar/modules/
```

3. Copy the waypick folder to your waybar modules directory:

```bash
cp -r waypick ~/.config/waybar/modules/
```

4. Make the script executable:

```bash
chmod +x ~/.config/waybar/modules/waypick/waypick.sh
```

5. Add the module to your waybar config (`~/.config/waybar/config.jsonc`):

```json
"custom/waypick": {
    "format": "{}",
    "return-type": "json",
    "interval": "once",
    "exec": "$HOME/.config/waybar/modules/waypick/waypick.sh",
    "on-click": "$HOME/.config/waybar/modules/waypick/waypick.sh pick && pkill -RTMIN+9 waybar",
    "on-click-right": "$HOME/.config/waybar/modules/waypick/waypick.sh copy",
    "signal": 9,
    "tooltip": true,
    "escape": false
}
```

6. Add the module to your modules-right (or modules-left/modules-center) array:

```json
"modules-right": ["custom/waypick", "pulseaudio", "battery", "clock"],
```

7. Style how you want, example:

```css
#custom-waypick {
  color: red;
  border-bottom: 2px solid red;
  font-family: monospace;
}
```

8. Restart waybar:

```bash
pkill waybar && sleep 1 && waybar &
```

## Usage

- **Left-click**: Launch hyprpicker to select a new color
- **Right-click**: Copy the current color to clipboard

## Customization

You can customize the appearance by editing the `style.css` file in the waypick module directory.

## License

MIT
