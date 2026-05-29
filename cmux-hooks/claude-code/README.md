# Claude Code — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`Stop,PermissionRequest,PostToolUse:Task`

Hooks fire on session stop, permission requests, and after Task tool finishes. Merge `settings.snippet.json` into `~/.claude/settings.json` (top-level `hooks` block).

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only claude-code
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .claude/settings.json)/hooks
cp cmux-notify.sh ~/$(dirname .claude/settings.json)/hooks/
chmod +x ~/$(dirname .claude/settings.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.claude/settings.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .claude/settings.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
