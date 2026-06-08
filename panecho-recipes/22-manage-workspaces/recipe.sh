#!/bin/bash
# Usage: ./recipe.sh <name> [cwd]
# Find-or-create a named workspace, then (re)name it. Prints its ref.
set -euo pipefail
NAME="${1:?missing workspace name}"
CWD="${2:-$PWD}"

# Socket auth: inside an app-spawned surface the shell authenticates
# automatically. From an EXTERNAL shell, export CMUX_SOCKET_PASSWORD (the
# password saved in Settings) or pass --password, or the CLI fails with
# "Failed to write to socket (Broken pipe, errno 32)".
#
# The CLI auto-discovers the socket at ~/.local/state/cmux/cmux.sock
# (override with CMUX_SOCKET_PATH; the active path is recorded in
# ~/.local/state/cmux/last-socket-path).

# workspace list (canonical; legacy alias: list-workspaces) — match by name.
REF=$(cmux workspace list --json \
  | jq -r --arg n "$NAME" '.result.workspaces[] | select(.name == $n) | .workspace_ref' \
  | head -n 1)

if [ -z "$REF" ]; then
  # workspace create == legacy new-workspace
  cmux workspace create --name "$NAME" --cwd "$CWD"
  REF=$(cmux workspace list --json \
    | jq -r --arg n "$NAME" '.result.workspaces[] | select(.name == $n) | .workspace_ref' \
    | head -n 1)
  echo "created $REF ($NAME)"
else
  # workspace rename == legacy rename-workspace
  cmux workspace rename "$REF" --title "$NAME"
  echo "reused $REF, ensured name=$NAME"
fi

echo "$REF"
