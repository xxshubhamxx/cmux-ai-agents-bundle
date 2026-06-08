#!/bin/bash
# Add to ~/.zshrc or ~/.bashrc — restores your Panecho session when a shell starts.
# Panecho's control socket lives at the XDG path ~/.local/state/cmux/cmux.sock, not /tmp.
# CMUX_SOCKET_PATH overrides it; the active path is recorded in ~/.local/state/cmux/last-socket-path.
SOCK="${CMUX_SOCKET_PATH:-$(cat "$HOME/.local/state/cmux/last-socket-path" 2>/dev/null || echo "$HOME/.local/state/cmux/cmux.sock")}"
# Only act when the app is NOT already running (no live socket). In that case
# `restore-session` launches Panecho and lets startup restore reopen the saved
# session — no socket password needed. If the app is already up, restoring from
# this external login shell would need --password / CMUX_SOCKET_PASSWORD, so skip it.
if command -v cmux >/dev/null 2>&1 && [ ! -S "$SOCK" ]; then
  cmux restore-session 2>/dev/null || true
fi
