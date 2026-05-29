#!/bin/bash
# cmux notification hook for Claude Code
# Reads the agent's event JSON from stdin and forwards it to cmux as a notification.
# Silent (exits 0) when not running inside cmux.

set -euo pipefail

# Exit silently if we are not inside a cmux session
SOCK="${CMUX_SOCKET_PATH:-/tmp/cmux.sock}"
[ -S "$SOCK" ] || exit 0

# Ensure cmux is on PATH
if ! command -v cmux >/dev/null 2>&1; then
    if [ -x /Applications/cmux.app/Contents/Resources/bin/cmux ]; then
        export PATH="/Applications/cmux.app/Contents/Resources/bin:$PATH"
    else
        exit 0
    fi
fi

# Parse the event JSON from stdin (best-effort — agents send different shapes)
EVENT=$(cat 2>/dev/null || true)
if command -v jq >/dev/null 2>&1; then
    EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // .event // .type // "unknown"' 2>/dev/null || echo "unknown")
else
    EVENT_TYPE="unknown"
fi

case "$EVENT_TYPE" in
    "Stop")
        cmux notify --title "Claude Code" --body "Session complete" ;;
    "PermissionRequest")
        cmux notify --title "Claude Code" --subtitle "Waiting" --body "Permission / approval needed" ;;
    "PostToolUse")
        cmux notify --title "Claude Code" --body "Tool finished" ;;
    *)
        # Unknown event — stay quiet
        ;;
esac

exit 0
