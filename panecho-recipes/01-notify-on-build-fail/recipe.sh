#!/bin/bash
# Usage: ./recipe.sh <command> [args...]
set -euo pipefail
LOG=$(mktemp)
trap 'rm -f "$LOG"' EXIT
if ! "$@" 2>&1 | tee "$LOG"; then
  TAIL=$(tail -n 5 "$LOG" | paste -sd '|' -)
  cmux notify --title "Build FAILED" --body "$TAIL"
  cmux trigger-flash
  exit 1
fi
cmux notify --title "Build OK" --body "Command finished successfully"
