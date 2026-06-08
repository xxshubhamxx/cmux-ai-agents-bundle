# Gate one surface on another with wait-for

Cross-process sync via a named token: a consumer in one surface blocks on
`cmux wait-for <name>` until a producer in another surface fires
`cmux wait-for -S <name>`. Lets an agent hold an integration step until a
sibling agent finishes its build — no polling, no shared file, no busy loop.

## Run

```bash
# in the consumer surface (blocks):
chmod +x recipe.sh
./recipe.sh wait build-done 120

# in the producer surface, once the build is green:
./recipe.sh signal build-done
```

See [`recipe.sh`](./recipe.sh) for the full script.

Inside a Panecho surface this authenticates automatically. From an external shell,
export `CMUX_SOCKET_PASSWORD` (the password saved in Settings) first, or both
sides fail with a broken-pipe error. The CLI auto-discovers the socket at
`~/.local/state/cmux/cmux.sock` (override with `CMUX_SOCKET_PATH`; the active
path is recorded in `~/.local/state/cmux/last-socket-path`).

`wait-for` defaults to a 30-second timeout; pass a longer one to the consumer for
slow steps. The token name is arbitrary — both sides just have to agree on it.
