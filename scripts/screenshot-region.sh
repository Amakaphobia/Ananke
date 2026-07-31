#!/usr/bin/env bash
set -eou pipefail
# screenshot a region

mkdir -p "$HOME/Pictures/Screenshots"

region="$(slurp)" || exit 0

grim -g "$region" -t ppm - |
  satty \
    --filename - \
    --copy-command wl-copy \
    --output-filename "$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
