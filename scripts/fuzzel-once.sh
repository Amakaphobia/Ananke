#!/usr/bin/env bash
set -euo pipefail
pgrep fuzzel >/dev/null 2>&1 && pkill fuzzel || fuzzel
