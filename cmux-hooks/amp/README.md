# Amp — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`thread.message,thread.complete`

Amp emits message and completion events. Merge snippet into `~/.amp/config.json`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only amp
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .amp/config.json)/hooks
cp cmux-notify.sh ~/$(dirname .amp/config.json)/hooks/
chmod +x ~/$(dirname .amp/config.json)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.json` into your config at:
#    ~/.amp/config.json
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .amp/config.json)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
