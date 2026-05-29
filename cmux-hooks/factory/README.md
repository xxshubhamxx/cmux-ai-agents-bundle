# Factory (droid) — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

Factory's droid CLI fires `PreToolUse` and `Stop`. Merge snippet into `~/.factory/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only factory
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .factory/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .factory/config.json)/hooks/
chmod +x ~/$(dirname .factory/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.factory/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .factory/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
