#!/usr/bin/env bash

# setup

set -u
set -o pipefail

system="${1:-x86_64-linux}"

welcome_msg="Welcome"

failed=0
script_directory="$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
    pwd
)"
repository_root="$(
  git -C "$script_directory" rev-parse --show-toplevel
)"

cd -- "$repository_root" || exit 1

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  redbold='\033[1;31m'
  greenbold='\033[1;32m'
  yellowbold='\033[1;33m'
  bluebold='\033[1;34m'
  reset='\033[0m'
else
  redbold=''
  greenbold=''
  yellowbold=''
  bluebold=''
  reset=''
fi

printf "\n%s\n\n" "$welcome_msg"

# check for dirty repo myself and later disable in nix checks
if [[ -n "$(git status --porcelain)" ]]; then
  printf '%bwarning:%b Git tree %s is dirty\n\n' "$yellowbold" "$reset" "$repository_root"
fi

# this functions runs the checks and handles loging
run_check() {
  local name="$1"
  shift

  printf '\n%b==>%b %s\n' "$bluebold" "$reset" "$name"

  if "$@"; then
    printf '%bPASS:%b %s\n' "$greenbold" "$reset" "$name"
  else
    printf '%bFAIL:%b %s\n' "$redbold" "$reset" "$name"
    failed=1
  fi
}

# call all checks

run_check \
  "Tracked Files" \
  bash "$script_directory/trackedfiles.sh"

run_check \
  "Formatting" \
  nix --no-warn-dirty build ".#checks.${system}.formatting" \
  --no-link \
  --print-build-logs

run_check \
  "Statix" \
  nix --no-warn-dirty build ".#checks.${system}.statix" \
  --no-link \
  --print-build-logs

run_check \
  "Deadnix" \
  nix --no-warn-dirty build ".#checks.${system}.deadnix" \
  --no-link \
  --print-build-logs

# exit with code 1 when a check failed
if [ $failed != 0 ]; then
  exit 1
fi
