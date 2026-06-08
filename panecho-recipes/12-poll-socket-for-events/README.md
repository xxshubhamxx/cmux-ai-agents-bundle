# Poll the socket for surface output

Poll the last N lines of a surface buffer over the control socket with `cmux read-screen` — useful for build-watchers and CI integrations.

## Run

```bash
chmod +x recipe.sh
./recipe.sh
```

See [`recipe.sh`](./recipe.sh) for the full script.
