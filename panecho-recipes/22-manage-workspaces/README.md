# Manage workspaces from a script

List workspaces, create one if a named workspace is missing, and rename it —
the building blocks an agent needs to carve out its own workspace before
spawning work into it. Uses the canonical `cmux workspace` noun:
`workspace list`, `workspace create` (= legacy `new-workspace`), and
`workspace rename <ws> --title <new>`.

## Run

```bash
chmod +x recipe.sh
./recipe.sh "Agent Build" ~/projects/myapp
```

See [`recipe.sh`](./recipe.sh) for the full script.

Inside a Panecho surface this authenticates automatically. From an external shell,
export `CMUX_SOCKET_PASSWORD` (the password saved in Settings) first, or
`workspace list` / `workspace create` / `workspace rename` fail with a
broken-pipe error. The CLI auto-discovers the socket at
`~/.local/state/cmux/cmux.sock` (override with `CMUX_SOCKET_PATH`; the active
path is recorded in `~/.local/state/cmux/last-socket-path`).

`workspace list` is the canonical form of the legacy `list-workspaces` alias,
and `workspace rename` replaces `rename-workspace` — the legacy verbs keep
working but print a one-time deprecation hint. Set `CMUX_QUIET=1` to silence it.
