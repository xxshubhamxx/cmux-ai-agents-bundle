#!/bin/bash
# Returns 0 if inside Panecho/cmux, 1 otherwise.
# Detection anchors on the env Panecho injects into every surface — NOT a fixed
# socket path (Panecho's socket lives under ~/Library/Application Support/cmux/).
SOCK="${CMUX_SOCKET_PATH:-}"
[ -n "$SOCK" ] && [ -S "$SOCK" ] || { echo "Not inside Panecho/cmux"; exit 1; }
[ -n "${CMUX_WORKSPACE_ID:-}" ] || { echo "No CMUX_WORKSPACE_ID"; exit 1; }
[ "${TERM_PROGRAM:-}" = "ghostty" ] || { echo "Not a Ghostty/cmux terminal"; exit 1; }
echo "Inside Panecho: workspace=$CMUX_WORKSPACE_ID surface=$CMUX_SURFACE_ID"
