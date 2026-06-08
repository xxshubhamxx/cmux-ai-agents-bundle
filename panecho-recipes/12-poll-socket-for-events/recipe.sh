#!/bin/bash
# Usage: ./recipe.sh surface:7 [lines] [interval-seconds]
# Polls a surface buffer over the control socket via the cmux CLI.
set -euo pipefail
SURF="${1:?missing surface ref}"
LINES="${2:-40}"
INTERVAL="${3:-2}"

# Socket auth: inside an app-spawned surface the shell already carries
# CMUX_SOCKET_PATH / CMUX_SURFACE_ID and authenticates automatically.
# From an EXTERNAL shell, export CMUX_SOCKET_PASSWORD (the password saved in
# Settings) or pass --password, or the CLI fails with
# "Failed to write to socket (Broken pipe, errno 32)".
#
# The CLI auto-discovers the socket at ~/.local/state/cmux/cmux.sock
# (override with CMUX_SOCKET_PATH; the active path is recorded in
# ~/.local/state/cmux/last-socket-path). No raw nc / JSON-RPC needed.
while true; do
  cmux read-screen --surface "$SURF" --scrollback --lines "$LINES"
  sleep "$INTERVAL"
done
