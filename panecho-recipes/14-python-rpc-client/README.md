# Minimal Python JSON-RPC client

~30 lines of Python — use this from any automation script (no `cmux` CLI spawn).

## Run

```bash
python3 recipe.py
```

See [`recipe.py`](./recipe.py) for the full script. It resolves the socket from
`$CMUX_SOCKET_PATH` (injected in every Panecho surface), falling back to the live
path in `~/.local/state/cmux/last-socket-path`, then the XDG default
`~/.local/state/cmux/cmux.sock`.

Socket control methods authenticate automatically inside an app-spawned surface
(the shell carries `CMUX_SURFACE_ID` / `CMUX_WORKSPACE_ID` / `CMUX_SOCKET_PATH`).
Run from an external shell without that surface context and the socket write fails
with a broken-pipe error — invoke through the `cmux` CLI there instead, which
forwards the saved Settings password (or `CMUX_SOCKET_PASSWORD` / `--password`).
