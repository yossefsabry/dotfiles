#!/bin/bash

# Take a screenshot of the full screen (without slurp) and save it
grim -g "$(slurp)" ~/Pictures/screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png

