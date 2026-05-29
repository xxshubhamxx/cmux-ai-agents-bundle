# cmux Hooks

Ready-to-run notification + session-resume hooks for every AI coding agent cmux supports. One installer detects which agents you have and wires up only those.

> Built from the official cmux v0.64.10 hook docs and the `cmux hooks setup` integration.

## What you get

For each supported agent:

- `cmux-notify.sh` — sends a `cmux notify` when the agent stops, finishes a tool call, or needs permission.
- A `settings.json` (or equivalent) snippet to register the hook with the agent.
- A README describing exactly what fires and when.

Supported agents (15):

Claude Code · Codex · Grok · Cursor · Gemini · Hermes · Copilot · OpenCode · Factory (droid) · Antigravity · Amp · CodeBuddy · Qoder · Pi · Rovo Dev

## Install

```bash
# From inside this repo
./install.sh
```

The installer:

1. Checks that `cmux` is on `PATH` and the socket exists.
2. Detects which of the 15 agents you actually have installed.
3. Copies the matching hook script + config to the right location (`~/.claude/`, `~/.codex/`, etc.).
4. Runs `cmux hooks setup` to register them with cmux's session-restore system.
5. Prints what was installed (and what was skipped) at the end.

Re-run any time. It is idempotent — existing scripts are backed up to `<file>.bak.YYYYMMDD`.

## Install one agent only

```bash
./install.sh --only claude-code
./install.sh --only codex,grok,cursor
```

## What the hooks actually do

All hooks share the same shape — they read the agent's event JSON from stdin and call `cmux notify`:

```bash
#!/bin/bash
[ -S "${CMUX_SOCKET_PATH:-/tmp/cmux.sock}" ] || exit 0       # not in cmux → silent

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // "unknown"')

case "$EVENT_TYPE" in
  "Stop")           cmux notify --title "Claude Code" --body "Session complete" ;;
  "PermissionRequest") cmux notify --title "Claude Code" --subtitle "Waiting" --body "Permission needed" ;;
esac
```

Each agent's folder has the right event names and customizations for that agent (Codex sends `PreToolUse` + `PermissionRequest`, Cursor sends `beforeShellExecution`, etc.).

## Uninstall

```bash
./install.sh --uninstall
```

Removes the scripts and restores `.bak` configs where present.

## Manual install (one agent)

If you don't trust the installer (fair):

```bash
# Example: Claude Code
mkdir -p ~/.claude/hooks
cp claude-code/cmux-notify.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/cmux-notify.sh

# Then merge claude-code/settings.snippet.json into ~/.claude/settings.json
# (the snippet shows the exact "hooks" block to add)
```

Each agent folder has a README with the exact paths and required merges.

## Troubleshooting

- **No notification when agent stops** → Check that `cmux` is on PATH inside the agent's shell (`which cmux`). Some agents run with a stripped PATH.
- **"Failed to connect to socket"** → You ran the agent outside a cmux terminal and your socket mode is `cmuxOnly`. Switch to `automation` in cmux Settings → Automation.
- **`jq: command not found`** → `brew install jq`. All hooks need it.
- **Hook fires but nothing shows up** → `cmux ping` to confirm the daemon is alive, then `cmux list-notifications` to see if it landed but the UI didn't surface it.

## License

MIT. Fork it, ship it inside your own agent setup.
