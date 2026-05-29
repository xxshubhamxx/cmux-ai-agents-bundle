# Antigravity CLI — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,PostToolUse,Stop`

Antigravity (`agy`) fires both pre and post tool events. Merge snippet into `~/.antigravity/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only antigravity
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .antigravity/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .antigravity/config.json)/hooks/
chmod +x ~/$(dirname .antigravity/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.antigravity/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .antigravity/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
