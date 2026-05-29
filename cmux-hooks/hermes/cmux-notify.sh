#!/bin/bash
# cmux notification hook for Hermes Agent
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
    "pre_tool_call")
        # PreToolUse can be noisy — only flash, do not push a sticky notification
        cmux trigger-flash --surface "${CMUX_SURFACE_ID:-}" 2>/dev/null || true ;;
    "post_tool_call")
        cmux notify --title "Hermes Agent" --body "Tool finished" ;;
    "approval_request")
        cmux notify --title "Hermes Agent" --subtitle "Waiting" --body "Permission / approval needed" ;;
    "session_complete")
        cmux notify --title "Hermes Agent" --body "Session complete" ;;
    *)
        # Unknown event — stay quiet
        ;;
esac

exit 0
