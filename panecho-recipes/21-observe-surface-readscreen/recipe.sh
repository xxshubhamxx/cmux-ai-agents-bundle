#!/bin/bash
# Usage: ./recipe.sh <surface-ref> [pattern] [lines] [interval-seconds]
# Read-only watch of ANOTHER surface; fires when [pattern] appears. The target
# never sees keystrokes or loses focus — read-screen only reads its buffer.
set -euo pipefail
SURF="${1:?missing surface ref, e.g. surface:2}"
PATTERN="${2:-}"
LINES="${3:-200}"
INTERVAL="${4:-2}"

# Socket auth: inside an app-spawned surface the shell already carries
# CMUX_SOCKET_PATH / CMUX_SURFACE_ID and authenticates automatically. From an
# EXTERNAL shell, export CMUX_SOCKET_PASSWORD (the password saved in Settings)
# or pass --password, or the CLI fails with
# "Failed to write to socket (Broken pipe, errno 32)".
#
# The CLI auto-discovers the socket at ~/.local/state/cmux/cmux.sock
# (override with CMUX_SOCKET_PATH; the active path is recorded in
# ~/.local/state/cmux/last-socket-path).

# read-screen and the tmux-compat capture-pane are interchangeable here:
#   cmux capture-pane --surface "$SURF" --scrollback --lines "$LINES"
while true; do
  SNAP=$(cmux read-screen --surface "$SURF" --scrollback --lines "$LINES")
  if [ -n "$PATTERN" ]; then
    if echo "$SNAP" | grep -E -- "$PATTERN" >/dev/null 2>&1; then
      HIT=$(echo "$SNAP" | grep -E -- "$PATTERN" | tail -n 1)
      cmux notify --title "Match on $SURF" --body "$HIT"
      exit 0
    fi
  else
    echo "$SNAP"
  fi
  sleep "$INTERVAL"
done
