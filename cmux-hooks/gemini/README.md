# Gemini CLI — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

Gemini fires `PreToolUse` and final `Stop`. Merge snippet into `~/.gemini/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only gemini
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .gemini/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .gemini/config.json)/hooks/
chmod +x ~/$(dirname .gemini/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.gemini/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .gemini/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
