# -*- coding: utf-8 -*-


def toggle_treetab(qtile):
    """
    description: Toggles between TreeTab and the previous layout.
    This function is used to switch between the TreeTab layout and the
    previous layout in the current group.

    parameters:
        qtile: The qtile instance.
    """
    current_layout = qtile.current_group.layout.name
    if current_layout == "treetab":
        qtile.current_group.setlayout("columns")  # Change this to your default layout
    else:
        qtile.current_group.setlayout("treetab")


