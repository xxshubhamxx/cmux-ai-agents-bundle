#!/bin/bash
# Usage: ./recipe.sh surface:7
set -euo pipefail
SURF="${1:?missing surface ref}"
# Panecho injects CMUX_SOCKET_PATH into every surface; fall back to the live path
# the cmux CLI records, then to the legacy upstream /tmp location.
SOCK="${CMUX_SOCKET_PATH:-$(cat "$HOME/Library/Application Support/cmux/last-socket-path" 2>/dev/null || echo /tmp/cmux.sock)}"
echo '{"id":"r","method":"surface.read_text","params":{"surface_id":"'"$SURF"'","lines":40}}' \
  | nc -U "$SOCK" \
  | jq .
