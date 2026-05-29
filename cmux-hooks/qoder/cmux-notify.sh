#!/bin/bash
# cmux notification hook for Qoder
set -euo pipefail
SOCK="${CMUX_SOCKET_PATH:-/tmp/cmux.sock}"
[ -S "$SOCK" ] || exit 0
if ! command -v cmux >/dev/null 2>&1; then
    [ -x /Applications/cmux.app/Contents/Resources/bin/cmux ] && \
        export PATH="/Applications/cmux.app/Contents/Resources/bin:$PATH" || exit 0
fi
EVENT=$(cat 2>/dev/null || true)
if command -v jq >/dev/null 2>&1; then
    EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // .event // .type // "unknown"' 2>/dev/null || echo "unknown")
else
    EVENT_TYPE="unknown"
fi
case "$EVENT_TYPE" in
    "PreToolUse")
        cmux trigger-flash --surface "${CMUX_SURFACE_ID:-}" 2>/dev/null || true ;;
    "Stop")
        cmux notify --title "Qoder" --body "Session complete" ;;
    *) ;;
esac
exit 0
