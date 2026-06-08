# Observe another surface without disrupting it

Tail a *different* surface's output read-only — no keystrokes, no focus steal, no
attach. An agent can watch a long-running build or sibling agent in another
surface and react when something interesting scrolls past. Uses `read-screen`
(canonical) or its tmux-compatible alias `capture-pane`; both take the same
flags and never touch the target's input.

## Run

```bash
chmod +x recipe.sh
./recipe.sh surface:2 "FAILED|error:" 200 2
```

See [`recipe.sh`](./recipe.sh) for the full script.

Inside a Panecho surface this authenticates automatically (the shell carries
`CMUX_SOCKET_PATH` / `CMUX_SURFACE_ID`). From an external shell, export
`CMUX_SOCKET_PASSWORD` (the password saved in Settings) or pass `--password`
first, or `read-screen` fails with a broken-pipe error. The CLI auto-discovers
the socket at `~/.local/state/cmux/cmux.sock` (override with `CMUX_SOCKET_PATH`;
the active path is recorded in `~/.local/state/cmux/last-socket-path`).

`read-screen` is a pure read of the target's buffer, so this is safe to point at
a surface another agent is actively driving — `capture-pane` is the drop-in tmux
name for the same call.
