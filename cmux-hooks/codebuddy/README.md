# CodeBuddy — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

CodeBuddy fires `PreToolUse` and `Stop`. Merge snippet into `~/.codebuddy/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only codebuddy
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .codebuddy/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .codebuddy/config.json)/hooks/
chmod +x ~/$(dirname .codebuddy/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.codebuddy/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .codebuddy/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
