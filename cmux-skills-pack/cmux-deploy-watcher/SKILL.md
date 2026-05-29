---
name: cmux-deploy-watcher
description: Tail a deploy (Vercel, GitHub Actions, Fly, Railway) and turn its status into sidebar pills + ring flashes. User keeps editing while the deploy runs in the background.
---

# cmux Deploy Watcher

Use this skill when the user says "watch the deploy", "tail Vercel", or "let me know when CI finishes".

## What it does

- Picks the right CLI for the platform (Vercel/GH/Fly/Railway).
- Spawns a focus-neutral surface that tails deploy logs.
- Updates a `deploy` status pill in the sidebar: queued → building → ready / failed.
- Flashes the surface and sends a notification on terminal state.

## Steps

```bash
WS="${CMUX_WORKSPACE_ID:?inside cmux only}"
PLATFORM="${1:-vercel}"   # vercel | gh | fly | railway

# Pick the tail command
case "$PLATFORM" in
  vercel)   CMD="vercel logs --follow" ;;
  gh)       CMD="gh run watch --interval 5" ;;
  fly)      CMD="fly logs -a $FLY_APP" ;;
  railway)  CMD="railway logs -f" ;;
  *) echo "Unknown platform: $PLATFORM"; exit 1 ;;
esac

# Helper pane (re-use or create)
PANE_ID=$(cmux list-panes --workspace "$WS" --json \
  | jq -r --arg me "$CMUX_SURFACE_ID" '.result.panes | map(select((.surfaces // []) | map(.surface_ref) | index($me) | not)) | .[0].pane_ref // empty')
[ -z "$PANE_ID" ] && {
  cmux new-pane --workspace "$WS" --type terminal --direction right --focus false
  PANE_ID=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
}

cmux new-surface --pane "$PANE_ID" --type terminal --focus false
DEPLOY_SURF=$(cmux list-pane-surfaces --pane "$PANE_ID" --json | jq -r '.result.surfaces[-1].surface_ref')

cmux set-status deploy "queued" --icon "arrow.up.circle" --color "#fbbf24" --workspace "$WS"
cmux send-surface --surface "$DEPLOY_SURF" "$CMD\n"

# Background poller: turn deploy state into pills + final notify
(
  while true; do
    BUF=$(echo '{"id":"r","method":"surface.read_text","params":{"surface_id":"'"$DEPLOY_SURF"'","lines":60}}' | nc -U "${CMUX_SOCKET_PATH:-/tmp/cmux.sock}")
    if echo "$BUF" | grep -qiE 'ready|deployed|success|completed|✓'; then
      cmux set-status deploy "ready" --color "#10b981" --workspace "$WS"
      cmux notify --title "Deploy ready" --body "$PLATFORM deploy finished successfully"
      cmux trigger-flash --surface "$DEPLOY_SURF"
      break
    fi
    if echo "$BUF" | grep -qiE 'error|failed|✗|fatal'; then
      cmux set-status deploy "FAIL" --color "#ef4444" --workspace "$WS"
      cmux notify --title "Deploy failed" --body "$PLATFORM deploy failed — check logs"
      cmux trigger-flash --surface "$DEPLOY_SURF"
      break
    fi
    if echo "$BUF" | grep -qiE 'building|in progress'; then
      cmux set-status deploy "building" --color "#3b82f6" --workspace "$WS"
    fi
    sleep 4
  done
) &
```

## Rules

- Surface is helper-pane. Never focus it. User keeps editing.
- Status pill is sticky until cleared or the deploy ends. Clear with `cmux clear-status deploy`.
