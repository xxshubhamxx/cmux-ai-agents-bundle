#!/bin/bash
set -euo pipefail
cmux workspace list --json | jq -c '.result.workspaces[]' | while read -r ws; do
  REF=$(echo "$ws" | jq -r '.workspace_ref')
  CWD=$(echo "$ws" | jq -r '.cwd // ""')
  [ -z "$CWD" ] && continue
  NAME=$(basename "$CWD")
  cmux workspace rename "$REF" --title "$NAME"
  echo "$REF -> $NAME"
done
