# Pi — cmux hook

Sends a `cmux notify` on the agent's lifecycle events.

## Events handled

`session.complete`

Pi emits a single `session.complete` event. Merge snippet into `~/.pi/config.json`.

## Install (this folder only)

```bash
./cmux-hooks/install.sh --only pi
```

## Manual install

```bash
mkdir -p ~/.pi/hooks
cp cmux-notify.sh ~/.pi/hooks/
chmod +x ~/.pi/hooks/cmux-notify.sh
# Then merge settings.snippet.json into ~/.pi/config.json
```
