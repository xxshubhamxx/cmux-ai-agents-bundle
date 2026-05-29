# Cursor CLI — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`beforeShellExecution,Stop`

Cursor's terminal agent fires `beforeShellExecution` before any shell command. Merge snippet into `~/.cursor/settings.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only cursor
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .cursor/settings.json)/hooks
cp cmux-notify.sh ~/$(dirname .cursor/settings.json)/hooks/
chmod +x ~/$(dirname .cursor/settings.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.cursor/settings.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .cursor/settings.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
