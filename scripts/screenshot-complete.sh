#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Pictures/Screenshots"
# complete screenshot
grim -t ppm - |
  satty \
    --filename - \
    --copy-command wl-copy \
    --output-filename "$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"

