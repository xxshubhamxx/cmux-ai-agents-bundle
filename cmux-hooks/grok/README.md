# Grok / Grok Build CLI — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

Grok's Build CLI fires `PreToolUse` on every tool execution. Merge snippet into `~/.grok/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only grok
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .grok/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .grok/config.json)/hooks/
chmod +x ~/$(dirname .grok/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.grok/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .grok/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
