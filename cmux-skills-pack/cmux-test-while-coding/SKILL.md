---
name: cmux-test-while-coding
description: Side-by-side layout: editor terminal on the left, watch-mode test runner on the right. Auto-flashes the test surface when status changes (red → green or vice versa).
---

# cmux Test-While-Coding

Use this skill when the user says "set up test-while-coding" or "I want tests on the side as I edit".

## What it does

- Keeps the user's current pane (editor) untouched.
- Creates ONE right-side helper pane running the test watcher.
- Flashes the test surface when the test status transitions (red → green, green → red).
- Updates a sidebar status pill so the user can see test state without switching tabs.

## Steps

```bash
WS="${CMUX_WORKSPACE_ID:?must run inside cmux}"

# Detect or create the right-side helper pane (re-use if it exists)
PANE_ID=$(cmux list-panes --workspace "$WS" --json \
  | jq -r --arg me "$CMUX_SURFACE_ID" '
      .result.panes
      | map(select((.surfaces // []) | map(.surface_ref) | index($me) | not))
      | .[0].pane_ref // empty
    ')

if [ -z "$PANE_ID" ]; then
  cmux new-pane --workspace "$WS" --type terminal --direction right --focus false
  PANE_ID=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
fi

# Add a test-runner surface in that pane
cmux new-surface --pane "$PANE_ID" --type terminal --focus false
TEST_SURFACE=$(cmux list-pane-surfaces --pane "$PANE_ID" --json | jq -r '.result.surfaces[-1].surface_ref')

# Pick the right test command — agent fills this from project introspection
TEST_CMD="${TEST_CMD:-npm test -- --watch}"
cmux send-surface --surface "$TEST_SURFACE" "$TEST_CMD\n"

# Pin a status pill the user can see in the sidebar
cmux set-status tests "running" --icon flask --color "#3b82f6" --workspace "$WS"
```

## Status-transition watcher (optional add-on)

Run this as a background watcher to flash on red/green transitions:

```bash
PREV=""
while true; do
  TEXT=$(cmux --json browser surface:NONE eval 'return ""' 2>/dev/null  # placeholder
         || echo "")
  # Better: read the surface buffer
  TEXT=$(echo '{"id":"r","method":"surface.read_text","params":{"surface_id":"'"$TEST_SURFACE"'","lines":40}}' | nc -U "$CMUX_SOCKET_PATH")
  if echo "$TEXT" | grep -qE 'FAIL|✗|failed'; then
    STATE="red"
  elif echo "$TEXT" | grep -qE 'PASS|✓|passed'; then
    STATE="green"
  else
    STATE="$PREV"
  fi
  if [ -n "$PREV" ] && [ "$STATE" != "$PREV" ]; then
    cmux trigger-flash --surface "$TEST_SURFACE"
    [ "$STATE" = "red" ]   && cmux set-status tests "FAIL" --color "#ef4444" --workspace "$WS"
    [ "$STATE" = "green" ] && cmux set-status tests "PASS" --color "#10b981" --workspace "$WS"
  fi
  PREV="$STATE"
  sleep 2
done
```

## Rules

- Do not focus the test surface. The user is in the editor.
- Do not call `select-workspace`.
- Use `set-status` / `trigger-flash` for attention; never grab keyboard focus.
