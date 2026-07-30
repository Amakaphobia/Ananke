#!/usr/bin/env bash
set -eou pipefail

case "$(nmcli radio wifi)" in
enabled)
  nmcli radio wifi off
  ;;
disabled)
  nmcli radio wifi on
  ;;
*)
  echo "Could not determine Wi-Fi state" >&2
  exit 1
  ;;
esac
