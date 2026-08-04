#!/usr/bin/env bash
set -euo pipefail

mapfile -t untracked_files < <(
  git ls-files --others --exclude-standard
)

if ((${#untracked_files[@]} > 0)); then
  printf 'Untracked files found:\n'
  printf '  %s\n' "${untracked_files[@]}"
  exit 1
fi
