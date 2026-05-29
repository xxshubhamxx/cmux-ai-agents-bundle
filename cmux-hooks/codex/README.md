# Codex — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,PermissionRequest,Stop`

Codex fires `PreToolUse` before each tool call and `PermissionRequest` when sandbox blocks. Merge snippet into `~/.codex/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only codex
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .codex/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .codex/config.json)/hooks/
chmod +x ~/$(dirname .codex/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.codex/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .codex/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
