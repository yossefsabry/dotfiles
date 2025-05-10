#!/bin/bash

# Use slurp to select the window region or area
selected_area=$(slurp)

# Check if the selection was cancelled or not valid
if [ -z "$selected_area" ]; then
  echo "Selection cancelled or invalid."
  exit 1
fi

# Capture the selected area and copy it to the clipboard
grim -g "$selected_area" - | wl-copy

