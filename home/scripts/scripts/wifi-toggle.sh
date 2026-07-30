#!/usr/bin/env bash
set -eou pipefail

wifi_state=$(nmcli radio wifi)

if [ "${wifi_state}" == "enabled" ]; then
  nmcli radio wifi off
else
  nmcli radio wifi on
fi
