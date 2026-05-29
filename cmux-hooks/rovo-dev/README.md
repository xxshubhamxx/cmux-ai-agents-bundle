# Rovo Dev — cmux hook

Sends a `cmux notify` on the agent's lifecycle events.

## Events handled

`session.end`

Atlassian's Rovo Dev (`acli rovodev`) fires `session.end`. Merge snippet into `~/.rovo/config.json`.

## Install (this folder only)

```bash
./cmux-hooks/install.sh --only rovo-dev
```

## Manual install

```bash
mkdir -p ~/.rovo/hooks
cp cmux-notify.sh ~/.rovo/hooks/
chmod +x ~/.rovo/hooks/cmux-notify.sh
# Then merge settings.snippet.json into ~/.rovo/config.json
```
