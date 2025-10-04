from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.config import Match, Rule
from libqtile.lazy import lazy
from libqtile.config import ScratchPad, DropDown
from function.switch_window import latest_group
from function.toggle_treetab import toggle_treetab
from function.battery_check import battery_warning
# from libqtile.utils import guess_terminal



# setup cursor theme
import subprocess
subprocess.run(["xsetroot", "-cursor_name", "left_ptr"])




# Rose Pine color scheme
colors = {
    "base": "#191724",
    "surface": "#1f1d2e",
    "text": "#e0def4",
    "love": "#eb6f92",
    "gold": "#f6c177",
    "pine": "#31748f",
    "foam": "#9ccfd8",
    "iris": "#c4a7e7",
    "highlight": "#26233a",
    "background": "#000000",  # Black background
    "active": "#31748f",  # Rose Pine blue
    "inactive": "#6e6a86",  # Rose Pine muted gray
    "urgent": "#eb6f92",  # Rose Pine pink
    "text": "#e0def4",  # Rose Pine text color
}


mod = "mod1"
#terminal = guess_terminal()
terminal = "kitty"
search_manager = "rofi -show drun -show-icons -icon-theme 'Papirus' -theme \
    ~/.config/rofi/config.rasi"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # switch between the last two window
    Key([mod], "b", lazy.function(latest_group)),
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # using defualt span in qtile
    Key([mod], "p", lazy.spawn(search_manager), desc="Launch rofi"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "m",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "f", lazy.window.toggle_floating(), 
        desc="Toggle floating on the focused window"),

    Key([mod], "t", lazy.function(lambda qtile: toggle_treetab(qtile)),
        desc="Toggle TreeTab Layout"),

    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # ignore for qutebrowser
    # Key([mod], "p", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # for toggle bar
    Key([mod], "n", lazy.hide_show_bar("bottom")),

    # creating a scratchpad
    Key([mod], "u", lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Toggle scratchpad terminal"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )



groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


layouts = [
    layout.Columns(border_focus_stack=[colors["active"], colors["pine"]], border_width=2),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    layout.TreeTab(
        place_right=True,
        margin_y=100,
        panel_width=200,
        vspace=8,
        section_fg=colors["text"],
        section_bg=colors["background"],
        bg_color=colors["background"],
        active_bg=colors["active"],
        active_fg=colors["text"],
        inactive_bg=colors["background"],
        inactive_fg=colors["inactive"],
        urgent_bg=colors["urgent"],
        urgent_fg=colors["text"],
    )
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=4,
)
extension_defaults = widget_defaults.copy()

# HINT NOT WORKING  FIXING THIS
# widget for battery and saving it here for adding a new function for 
# to check for the battery precent and send a warning for me when 
# it's less than 20 or 10 precent (send a notify-send warning )
battery = widget.Battery(
    format='{char} {percent:2.0%}',
    charge_char='↑',
    discharge_char='↓',
    empty_char='⚠',
    unknown_char='?',
    full_char='⚡',
    update_interval=30,
    low_percentage=0.2,
    low_foreground='#ff0000',  # red text when low battery
)

# Attach your function to run after each update
battery.add_callbacks({"update": lambda w: battery_warning(battery)})


screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(
                    highlight_method="block",
                    invert_mouse_wheel=True,  # optional: prevents accidental scrolling
                    active="#e0def4",   # text for active groups
                    inactive="#6e6a86", # text for inactive groups
                    this_current_screen_border="#9ccfd8",  # focused group highlight (foam)
                    this_screen_border="#31748f",          # other screen (pine)
                    other_current_screen_border="#c4a7e7", # other screen focused (iris)
                    other_screen_border="#908caa",         # other screen unfocused (subtle)
                    block_highlight_text_color="#191724",  # text color when highlighted
                    highlight_color=["#21202e", "#403d52"], # background highlight layers
                    use_mouse_wheel=False,    # disables mouse wheel switching
                    disable_drag=True,
                    # ⬇️ keeps all groups visible in fixed order
                    visible_groups=[str(i) for i in range(1, 10)],
                ),
                widget.Prompt(),
                widget.WindowName(),
                widget.TextBox("Press &lt;M-p&gt; to spawn", 
                               foreground="#d75f5f"),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.CPU(
                    format="Cpu: 󰘚 {load_percent}%",
                    foreground=colors["iris"],
                    padding=5,
                ),
                widget.Memory(
                    format="Ram: 󰍛 {MemUsed:.0f}M/{MemTotal:.0f}M",
                    foreground=colors["gold"],
                    padding=5,
                ),
                widget.KeyboardLayout(
                    configured_keyboards=["us", "ara"],
                    fmt="Lang: {}",
                    foreground=colors["iris"],
                    padding=5,
                    update_interval=1,  # Refreshes the widget every second
                ),
                battery,
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.DF(
                    format=" : {uf:.1f}G free",
                    visible_on_warn=False,
                    partition="/",
                    foreground=colors["foam"],
                    padding=5,
                ),
                widget.Volume(
                    fmt="   :{}",
                    foreground=colors["love"],
                    padding=5,
                ),
                widget.QuickExit(),
                widget.Systray(),
            ],
            23,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating 
        #resize/moving is laggy # By default we handle these events delayed to already improve performance, however your system might still be struggling This variable is set to None (no cap) by default, but you can 
        # set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
# IGNORE ERROR IN TYPE
dgroups_app_rules = [
    Rule(Match(wm_class="brave-browser"), group="2"),  # type: ignore
    Rule(Match(wm_class="falkon"), group="2"),  # type: ignore
    Rule(Match(wm_class="Brave-browser"), group="2"),  # type: ignore
    Rule(Match(wm_class="qutebrowser"), group="2"),  # type: ignore

    # Workspace 3
    Rule(Match(wm_class="discord"), group="3"),  # type: ignore
    Rule(Match(wm_class="Microsoft To-Do Unofficial"), group="3"),  # type: ignore
    Rule(Match(wm_class="kuro"), group="3"),  # type: ignore
    Rule(Match(wm_class="Kuro"), group="3"),  # type: ignore
    Rule(Match(wm_class="mpv"), group="3"),  # type: ignore
    Rule(Match(wm_class="lg"), group="3"),  # type: ignore

    # Workspace 4
    Rule(Match(wm_class="obsidian"), group="4"),  # type: ignore
    Rule(Match(wm_class="Zathura"), group="4"),  # type: ignore
    Rule(Match(wm_class="code"), group="4"),  # type: ignore
    Rule(Match(wm_class="KeePassXC"), group="4"),  # type: ignore
    Rule(Match(wm_class="keepassxc"), group="4"),  # type: ignore

    # Workspace 5
    Rule(Match(wm_class="Nemo"), group="5"),  # type: ignore
    Rule(Match(wm_class="Zeal"), group="5"),  # type: ignore
    Rule(Match(wm_class="com.github.th_ch.youtube_music"), group="5"),  # type: ignore
    Rule(Match(wm_class="youtube music desktop app"), group="5"),  # type: ignore
    Rule(Match(wm_class="Youtube Music Desktop App"), group="5"),  # type: ignore
    Rule(Match(wm_class="fooyin"), group="5"),  # type: ignore
    Rule(Match(wm_class="QtSpim"), group="5"),  # type: ignore
    Rule(Match(wm_class="install4j-burp-StartBurp"), group="5"),  # type: ignore

    # Workspace 6
    Rule(Match(wm_class="Postman"), group="6"),  # type: ignore
    Rule(Match(wm_class="steam"), group="6"),  # type: ignore
    Rule(Match(wm_class="steamwebhelper"), group="6"),  # type: ignore
    Rule(Match(wm_class="Lutris"), group="6"),  # type: ignore
    Rule(Match(wm_class="net.lutris.Lutris"), group="6"),  # type: ignore
    Rule(Match(wm_class="Youtube Music"), group="6"),  # type: ignore

    # Workspace 7
    Rule(Match(wm_class="Gimp"), group="7"),  # type: ignore
    Rule(Match(wm_class="gimp-3.0"), group="7"),  # type: ignore
    Rule(Match(wm_class="Gimp-2.10"), group="7"),  # type: ignore
    Rule(Match(wm_class="VirtualBox Manager"), group="7"),  # type: ignore

    Rule(Match(wm_class="obs"), group="7"),  # type: ignore
    Rule(Match(wm_class="obs"), group="7"),  # type: ignore
    
]


# append the scratchpad group with a dropdown terminal
groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", terminal, width=0.8, height=0.8, x=0.1, y=0.10)
    ])
)


follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


