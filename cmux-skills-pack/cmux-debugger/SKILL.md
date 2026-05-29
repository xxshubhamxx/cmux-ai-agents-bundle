---
name: cmux-debugger
description: Four-pane debugging layout: REPL, logs, code, embedded browser — all wired together so a fix in code triggers a browser reload and log flash.
---

# cmux Debugger Layout

Use this skill when the user says "set up a debug layout" or "I need to see logs, code, and the browser together".

## What it does

Creates a 4-quadrant layout in the caller's workspace:

```
┌─────────────────┬─────────────────┐
│  code (editor)  │  embedded       │
│                 │  browser        │
├─────────────────┼─────────────────┤
│  logs / tail    │  REPL / shell   │
└─────────────────┴─────────────────┘
```

- Code: stays in the caller's current surface.
- Browser: WKWebView surface pointed at the app (default `http://localhost:3000`).
- Logs: tails a log file or runs `tail -F`.
- REPL: language REPL (Python/Node/bun/etc.) so user can poke at state.

## Steps

```bash
WS="${CMUX_WORKSPACE_ID:?inside cmux}"
APP_URL="${APP_URL:-http://localhost:3000}"
LOG_FILE="${LOG_FILE:-/tmp/app.log}"
REPL_CMD="${REPL_CMD:-node}"

# Create the right column (browser top, repl bottom)
cmux new-pane --workspace "$WS" --type browser --direction right --focus false --url "$APP_URL"
RIGHT_TOP=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
BROWSER_SURF=$(cmux list-pane-surfaces --pane "$RIGHT_TOP" --json | jq -r '.result.surfaces[-1].surface_ref')

cmux new-pane --workspace "$WS" --type terminal --direction down --focus false --pane "$RIGHT_TOP"
RIGHT_BOT=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
REPL_SURF=$(cmux list-pane-surfaces --pane "$RIGHT_BOT" --json | jq -r '.result.surfaces[-1].surface_ref')
cmux send-surface --surface "$REPL_SURF" "$REPL_CMD\n"

# Bottom-left logs (split off the caller's surface downward)
cmux split-off --surface "$CMUX_SURFACE_ID" down
LOGS_PANE=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
LOGS_SURF=$(cmux list-pane-surfaces --pane "$LOGS_PANE" --json | jq -r '.result.surfaces[-1].surface_ref')
cmux send-surface --surface "$LOGS_SURF" "tail -F $LOG_FILE\n"

# Wire up: when code is saved (caller signals it), reload browser and flash logs
echo "Debugger ready."
echo "To reload + flash: cmux browser $BROWSER_SURF reload && cmux trigger-flash --surface $LOGS_SURF"
```

## Rules

- The user's editor surface stays as-is. We only ADD panes.
- All splits are `--focus false`.
- Don't reload the browser on every keystroke — only on explicit user save signal.
