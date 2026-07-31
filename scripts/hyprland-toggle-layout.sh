#!/usr/bin/env bash

set -euo pipefail

# get the name of the current layout
# uses jq to extract that string
current_layout="$(
  hyprctl -j getoption general.layout |
    jq -r '.str'
)"

# set next_layout based on the string
if [[ "$current_layout" == "master" ]]; then
  next_layout="scrolling"
else
  next_layout="master"
fi

# request hyprctl to change layout to the previously decided upon layout
hyprctl -r eval "hl.config({ general = { layout = \"$next_layout\" } })"
