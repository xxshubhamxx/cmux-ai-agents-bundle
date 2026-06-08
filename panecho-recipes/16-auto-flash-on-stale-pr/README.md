# Flash a workspace when its PR goes stale

Cron-friendly: detect workspaces whose linked PR has comments since last visit and flash them.

## Run

```bash
chmod +x recipe.sh
./recipe.sh
```

See [`recipe.sh`](./recipe.sh) for the full script.

Running from cron is an external shell with no surface context, so export
`CMUX_SOCKET_PASSWORD` (the password saved in Settings) before the run — otherwise
`workspace list` and `trigger-flash` fail with a broken-pipe error.
