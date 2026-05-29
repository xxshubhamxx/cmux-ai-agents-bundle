# OpenCode — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`tool.before,tool.after,session.stop`

OpenCode uses a plugin event bus. Merge snippet into `~/.opencode/config.json` under `plugins:`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only opencode
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .opencode/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .opencode/config.json)/hooks/
chmod +x ~/$(dirname .opencode/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.opencode/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .opencode/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
