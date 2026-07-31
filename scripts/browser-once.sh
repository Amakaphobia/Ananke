#!/usr/bin/env bash
set -euo pipefail
if hyprctl clients -j |
  jq -e '
    any(.[];
      (((.class // "") | ascii_downcase) == "firefox")
      or
      (((.initialClass // "") | ascii_downcase) == "firefox")
    )
  ' >/dev/null
then
  exit 0
fi
exec firefox
