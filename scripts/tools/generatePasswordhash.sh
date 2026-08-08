#! /usr/bin/env bash

set -euo pipefail

while true; do
  read -s -r -p "Password: " p1
  echo
  read -s -r -p "Retype password: " p2
  echo

  if [[ "$p1" != "$p2" ]]; then
    echo "Passwords do not match"
  else
    printf '%s\n' "$p1" | nix shell nixpkgs#whois -c mkpasswd -m yescrypt -s
    break
  fi
done

unset p1 p2
