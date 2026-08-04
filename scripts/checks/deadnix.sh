#!/usr/bin/env bash
set -euo pipefail

source_directory="${1:?Usage: deadnix.sh SOURCE_DIRECTORY}"

cd -- "$source_directory"
deadnix --fail .
