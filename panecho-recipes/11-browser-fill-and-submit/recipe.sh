#!/bin/bash
# Usage: ./recipe.sh https://yoursite.com/contact "Jane" "jane@example.com"
# Socket auth: run inside an app-spawned surface (auto-authenticates) or, from an
# external shell, export CMUX_SOCKET_PASSWORD / pass --password — otherwise every
# command fails with "Failed to write to socket (Broken pipe, errno 32)".
set -euo pipefail
URL="$1"; NAME="$2"; EMAIL="$3"
# browser open creates a split in the caller's workspace and prints JSON with --json.
SURF=$(cmux --json browser open "$URL" | jq -r '.result.surface_ref // .surface_ref')
cmux browser "$SURF" wait --load-state complete --timeout-ms 15000
cmux browser "$SURF" snapshot --interactive
# Replace e1/e2/e3 with the element refs printed by the snapshot above.
cmux browser "$SURF" fill e1 "$NAME"
cmux browser "$SURF" fill e2 "$EMAIL"
cmux browser "$SURF" click e3
cmux browser "$SURF" wait --text "Thanks" --timeout-ms 10000
cmux browser "$SURF" snapshot --interactive
