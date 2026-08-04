#!/usr/bin/env bash
set -euo pipefail

source_directory="${1:?Usage: formatting.sh SOURCE_DIRECTORY}"

cd -- "$source_directory"
treefmt --ci --tree-root "$source_directory"
