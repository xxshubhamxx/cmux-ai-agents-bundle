# Qoder — cmux hook

Sends a `cmux notify` on the agent's lifecycle events.

## Events handled

`PreToolUse,Stop`

Qoder fires `PreToolUse` and `Stop`. Merge snippet into `~/.qoder/config.json`.

## Install (this folder only)

```bash
./cmux-hooks/install.sh --only qoder
```

## Manual install

```bash
mkdir -p ~/.qoder/hooks
cp cmux-notify.sh ~/.qoder/hooks/
chmod +x ~/.qoder/hooks/cmux-notify.sh
# Then merge settings.snippet.json into ~/.qoder/config.json
```
