#!/bin/bash
# Usage:
#   ./recipe.sh wait   <name> [timeout-seconds]   # block until the token fires
#   ./recipe.sh signal <name>                     # release everyone waiting
set -euo pipefail
MODE="${1:?missing mode: wait|signal}"
NAME="${2:?missing token name}"
TIMEOUT="${3:-30}"

# Socket auth: inside an app-spawned surface the shell authenticates
# automatically. From an EXTERNAL shell, export CMUX_SOCKET_PASSWORD (the
# password saved in Settings) or pass --password, or the CLI fails with
# "Failed to write to socket (Broken pipe, errno 32)".
#
# The CLI auto-discovers the socket at ~/.local/state/cmux/cmux.sock
# (override with CMUX_SOCKET_PATH; the active path is recorded in
# ~/.local/state/cmux/last-socket-path).

case "$MODE" in
  wait)
    # Blocks until another process signals NAME, or TIMEOUT seconds elapse.
    if cmux wait-for "$NAME" --timeout "$TIMEOUT"; then
      echo "token '$NAME' fired — proceeding"
    else
      echo "timed out after ${TIMEOUT}s waiting on '$NAME'" >&2
      exit 1
    fi
    ;;
  signal)
    # -S releases every waiter blocked on NAME.
    cmux wait-for -S "$NAME"
    echo "signaled '$NAME'"
    ;;
  *)
    echo "unknown mode: $MODE (use wait|signal)" >&2
    exit 2
    ;;
esac
