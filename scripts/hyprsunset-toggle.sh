#!/usr/bin/env bash

set -euo pipefail

case "$(systemctl --user is-active hyprsunset.service)" in
inactive)
  systemctl --user start hyprsunset.service
  ;;
active)
  systemctl --user stop hyprsunset.service
  ;;
*)
  printf "Could not determine hyprsunset status" 1>&2
  exit 1
  ;;
esac
