# Hermes Agent — cmux hook

Sends a `cmux notify` (and flashes the surface) on the agent's lifecycle events.

## Events handled

`pre_tool_call,post_tool_call,approval_request,session_complete`

Hermes uses YAML config and emits four event types. Merge snippet into `~/.hermes/config.yaml` under `hooks:`.

## Install (this folder only)

```bash
# From the repo root
./cmux-hooks/install.sh --only hermes
```

## Manual install

```bash
# 1. Copy the hook script
mkdir -p ~/$(dirname .hermes/config.yaml)/hooks
cp cmux-notify.sh ~/$(dirname .hermes/config.yaml)/hooks/
chmod +x ~/$(dirname .hermes/config.yaml)/hooks/cmux-notify.sh

# 2. Merge `settings.snippet.yaml` into your config at:
#    ~/.hermes/config.yaml
```

## Test it

```bash
echo '{"hook_event_name":"Stop"}' | ~/$(dirname .hermes/config.yaml)/hooks/cmux-notify.sh
# Should see a "Session complete" notification in the cmux sidebar.
```
