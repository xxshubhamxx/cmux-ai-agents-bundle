#!/bin/bash
# Add to ~/.zshrc or ~/.bashrc — restores your Panecho session when a shell starts.
# Panecho's socket lives under ~/Library/Application Support/cmux/, not /tmp.
SOCK="${CMUX_SOCKET_PATH:-$(cat "$HOME/Library/Application Support/cmux/last-socket-path" 2>/dev/null || echo /tmp/cmux.sock)}"
if command -v cmux >/dev/null 2>&1 && [ -n "$SOCK" ] && [ -S "$SOCK" ]; then
  cmux restore-session 2>/dev/null || true
fi
