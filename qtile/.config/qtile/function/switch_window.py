# -*- coding: utf-8 -*-

def latest_group(qtile):
    """
    description: Switch to the latest group in the current screen.
    This function is used to switch to the last group that was active
    on the current screen.
    parameters:
        qtile: The qtile instance.
    """
    qtile.current_screen.set_group(qtile.current_screen.previous_group)
