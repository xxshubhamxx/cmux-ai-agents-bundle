# Batch-rename workspaces by cwd

Loop over all workspaces and set their name to the basename of their cwd. Tidies up after a busy day.

## Run

```bash
chmod +x recipe.sh
./recipe.sh
```

See [`recipe.sh`](./recipe.sh) for the full script.

Inside a Panecho surface this authenticates automatically. From an external shell,
export `CMUX_SOCKET_PASSWORD` (the password saved in Settings) first, or
`workspace list` / `workspace rename` fail with a broken-pipe error.

`workspace rename` (canonical) replaces the legacy `rename-workspace`, which still
works but prints a one-time deprecation hint.
