# Minimal Python JSON-RPC client

~30 lines of Python — use this from any automation script (no `cmux` CLI spawn).

## Run

```bash
python3 recipe.py
```

See [`recipe.py`](./recipe.py) for the full script. It resolves the socket from
`$CMUX_SOCKET_PATH` (injected in every Panecho surface), falling back to the live
path in `~/Library/Application Support/cmux/last-socket-path`.
