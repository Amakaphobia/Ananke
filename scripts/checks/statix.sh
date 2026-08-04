#!/usr/bin/env bash
set -euo pipefail

source_directory="${1:?Usage: statix.sh SOURCE_DIRECTORY}"
statix_log="$(mktemp)"

cd -- "$source_directory"

statix_status=0
statix check . >"$statix_log" 2>&1 || statix_status=$?

cat "$statix_log"

if ((statix_status != 0)) || [[ -s "$statix_log" ]]; then
  exit 1
fi
