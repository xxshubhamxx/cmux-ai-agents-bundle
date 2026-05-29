# GitHub Copilot CLI — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

Copilot CLI fires `PreToolUse` before each action. Merge snippet into `~/.copilot/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only copilot
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .copilot/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .copilot/config.json)/hooks/
chmod +x ~/$(dirname .copilot/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.copilot/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .copilot/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
