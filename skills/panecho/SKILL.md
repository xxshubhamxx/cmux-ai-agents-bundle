---
name: panecho
description: Drive the Panecho native macOS terminal app (the privacy-hardened fork of cmux) from CLI or socket — workspaces, panes, surfaces, browser automation, notifications, sidebar metadata, session restore. Use whenever the user mentions Panecho or cmux, wants to control terminal layout from an agent, automate browser panels on macOS, send notifications/flashes to the sidebar, or integrate an AI agent with Panecho/cmux hooks. macOS only (14.0+). Note: privacy mode is ON by default and disables update/analytics/crash/remote-auth network paths.
---

# Panecho Control

Panecho is a privacy-hardened fork of cmux — a native macOS terminal app for running multiple AI coding agents in parallel. It ships the **same `cmux` CLI** and the **same Unix-socket JSON-RPC API** (default socket `~/.local/state/cmux/cmux.sock`, overridable via `$CMUX_SOCKET_PATH`) as upstream, so every command below works verbatim. Only the app bundle (`Panecho.app`, `io.panecho.app`) and URL scheme (`panecho`) are rebranded — and **privacy mode is enabled by default** (see "Privacy Mode — What Changes" below).

Current release: **panecho-v0.64.15** — Developer ID signed (Browserstack Inc, Team `YQ5FZQ855D`) + notarized + stapled. Latest: https://github.com/xxshubhamxx/cmux-panecho/releases/latest

## Core Concepts

- **Window** — top-level macOS Panecho window
- **Workspace** — sidebar tab within a window (one git branch / project context)
- **Pane** — split region inside a workspace
- **Surface** — tab inside a pane (terminal or browser)

Handles default to short refs (`workspace:2`, `pane:1`, `surface:7`); UUIDs accepted as input. Add `--id-format uuids|both` for full IDs in output.

## Detect Panecho in a Shell

```bash
[ -n "${CMUX_SOCKET_PATH:-}" ] && [ -S "$CMUX_SOCKET_PATH" ] || exit 0   # bail if not inside a Panecho surface
[ -n "${CMUX_WORKSPACE_ID:-}" ] && echo "inside a Panecho surface"
```

Injected env vars in every Panecho-spawned terminal: `CMUX_WORKSPACE_ID`, `CMUX_SURFACE_ID`, `CMUX_SOCKET_PATH`, `CMUX_PORT` (env var names keep the `CMUX_` prefix for drop-in compatibility). **Always anchor automation to `CMUX_WORKSPACE_ID`** — the visually focused workspace may not be the agent's caller workspace.

## Connecting to the Socket (Auth)

Socket control commands (`ping`, `notify`, `new-pane`, `send`, `list-*`, `workspace list`, `read-screen`, `events`, etc.) need to authenticate to the control socket. How that happens depends on where the command runs:

- **Inside an app-spawned surface (no password needed).** The surface shell carries `CMUX_SURFACE_ID` / `CMUX_WORKSPACE_ID` / `CMUX_SOCKET_PATH`, so the CLI authenticates **automatically**. This is the normal case for an agent running in a Panecho terminal — just call commands directly.
- **From an external shell (password required).** A shell that Panecho did not spawn has none of those env vars. You must pass `--password <pw>` or set `CMUX_SOCKET_PASSWORD` (the password saved in **Settings**). Resolution order: `--password` takes precedence, then `CMUX_SOCKET_PASSWORD`, then the saved Settings password.
- **Symptom of missing auth:** an unauthenticated external command fails with `Failed to write to socket (Broken pipe, errno 32)`. If you see this, you are running outside a surface without a password — supply one rather than retrying.
- **No auth required:** the bare launcher `cmux <path>` (open a directory in a new workspace), the read-only `cmux <cmd> --help`, and `cmux docs <topic>` all work without any socket connection or password.

The default socket is `~/.local/state/cmux/cmux.sock`; override with `CMUX_SOCKET_PATH`. The active path is also written to `~/.local/state/cmux/last-socket-path`, which is what the CLI auto-discovers. (`cmux auth <status|login|logout>` is a separate concern — it governs remote/web sign-in, which is gated off under privacy mode, not socket access.)

## Fast Start — Topology

```bash
cmux identify --json                              # server identity + caller context (window/workspace/pane/surface)
cmux tree                                         # full hierarchy
cmux workspace list --json                                 # canonical; `list-workspaces` is a still-supported alias
cmux list-panes --workspace "$CMUX_WORKSPACE_ID"
cmux list-pane-surfaces --pane pane:1                       # surfaces (tabs) within a pane

cmux new-workspace --name "feature-x" --cwd /path/to/repo
cmux new-pane --workspace "$CMUX_WORKSPACE_ID" --type terminal --direction right --focus false
cmux new-pane --workspace "$CMUX_WORKSPACE_ID" --type browser  --direction right --url http://localhost:3000
cmux move-surface --surface surface:7 --pane pane:2 --focus false
cmux split-off --surface surface:7 right
cmux reorder-surface --surface surface:7 --before surface:3
cmux close-surface --surface surface:7
```

## Send Input

```bash
cmux send "echo hi\n"                                       # focused terminal
cmux send-key "ctrl+c"                                       # enter|tab|esc|backspace|arrows|ctrl+x|shift+tab
cmux send --surface surface:7 "npm run build\n"              # specific surface
cmux send-key --surface surface:7 enter
```

## Read Terminal Output

```bash
cmux read-screen                                            # visible viewport of caller surface as plain text
cmux read-screen --surface surface:2 --scrollback --lines 200   # last 200 lines incl. scrollback
cmux capture-pane --surface surface:1 --scrollback --lines 200  # tmux-compatible alias for read-screen
```

## Wait & Watch (sync + events)

```bash
cmux wait-for build-done --timeout 60                       # block until token signaled (default 30s)
cmux wait-for -S build-done                                 # signal the token (e.g. from another surface)
cmux events --category notification                         # stream cmux events as newline-delimited JSON
cmux events --cursor-file ~/.cache/cmux/events.seq --reconnect   # durable resume across reconnects
```

## Notifications & Sidebar Metadata

```bash
cmux notify --title "Done" --body "tests passed"
cmux set-status build "compiling" --icon hammer --color "#ff9500"
cmux set-progress 0.5 --label "Building..."
cmux log --level success "All 42 tests passed"               # info|progress|success|warning|error
cmux trigger-flash --workspace "$CMUX_WORKSPACE_ID"          # blue-ring attention cue
cmux sidebar-state --json                                    # dump all sidebar metadata
```

## Browser Automation (WKWebView)

Workflow: open → wait → snapshot → act → re-snapshot.

```bash
S=$(cmux --json browser open https://example.com | jq -r .result.surface_ref)
cmux browser "$S" wait --load-state complete --timeout-ms 15000
cmux browser "$S" snapshot --interactive                     # returns elements as e1, e2, ...
cmux browser "$S" fill e1 "jane@example.com"
cmux browser "$S" click e2 --snapshot-after

# Navigation / inspection
cmux browser "$S" goto URL | back | forward | reload
cmux browser "$S" get url | get title | get text body | get value "#email" | get count ".row"
cmux browser "$S" eval 'return document.title'

# Waits
cmux browser "$S" wait --selector "#ready" --timeout-ms 10000
cmux browser "$S" wait --url-contains "/dashboard" --timeout-ms 10000

# Session
cmux browser "$S" cookies get | cookies set --name foo --value bar
cmux browser "$S" state save /tmp/auth.json | state load /tmp/auth.json

# Diagnostics
cmux browser "$S" console list | errors list | screenshot
```

**Not supported by WKWebView** (return `not_supported`): viewport emulation, geolocation/offline emulation, trace recording, network route interception, raw input injection.

> **Privacy-mode note:** the browser loads whatever URL you point it at — WKWebView page loads are **not** subject to Panecho's `URLSession` egress guard. Treat browser surfaces as normal outbound network. The guard only fail-closes the app's own `URLSession` traffic (telemetry/update/auth), not pages you choose to open.

## Markdown Viewer

```bash
cmux markdown open plan.md --focus false                     # live-watching renderer (non-disruptive)
cmux open file.pdf                                           # auto-routes to right viewer
```

## Settings & Config

```bash
cmux docs settings        # prints paths, schema URL, reload cmd — read BEFORE editing
cmux settings path        # path to cmux.json
cmux settings cmux-json   # open in editor
cmux reload-config        # hot-reload cmux.json + ~/.config/ghostty/config (Cmd+Shift+,)
```

Locations:
- Panecho settings: `~/.config/cmux/cmux.json` (canonical — path keeps the `cmux` name for drop-in compatibility). Project-local override: `.cmux/cmux.json` or `./cmux.json`.
- Terminal rendering (font, cursor, theme, scrollback, opacity, blur): `~/.config/ghostty/config` — NOT cmux.json.

Before editing `cmux.json`, copy it to a timestamped `.bak` next to it so the user can revert. Schema (tracks upstream cmux, identical for Panecho): `https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json`.

## Privacy Mode — What Changes

Panecho runs with privacy mode **on by default**. An agent must expect these paths to be inert and handle the errors gracefully rather than retrying:

| Subsystem | Behavior in Panecho | What the agent sees |
|---|---|---|
| Auto-update (Sparkle) | Disabled — no feed URL, no auto/manual check | `cmux`/UI update commands report a disabled state |
| Analytics (PostHog) | Compiled out — SDK not linked | nothing; no-op |
| Crash reporting (Sentry) | Compiled out — SDK not linked | nothing; no-op |
| Remote auth sign-in | Gated off | sign-in throws a "privacy mode" error |
| Cloud/VM provisioning | Off by default | `cmux vm …` returns a privacy-mode error |
| Remote-daemon download | Gated off | falls back to offline/local build |
| Outbound `URLSession` to non-loopback hosts | Fail-closed by an egress guard | request fails with a "blocked by privacy mode" error |

**Still fully functional (user-initiated):** local socket control, terminal panes, SSH workspaces you start, browser tabs you open, notifications, layout/topology commands. Privacy mode does not sandbox child processes (`ssh`, `ghostty`, your shells), WKWebView page loads, or raw sockets — only the app's own `URLSession` egress.

**Agent rule:** never assume update/analytics/cloud/remote-auth calls will succeed. If a feature returns a privacy-mode error, surface it to the user — do not loop retrying.

## Agent Hooks & Install

```bash
# Install Panecho.app from the fork's releases (no Homebrew cask):
#   https://github.com/xxshubhamxx/cmux-panecho/releases/latest  (asset: panecho-macos.zip)
ditto -x -k ~/Downloads/panecho-macos.zip /tmp/panecho && ditto /tmp/panecho/Panecho.app /Applications/Panecho.app
sudo ln -sf /Applications/Panecho.app/Contents/Resources/bin/cmux /usr/local/bin/cmux

cmux hooks setup                                             # all detected agents
cmux hooks setup codex|grok|antigravity|opencode             # specific agent
npx skills add manaflow-ai/cmux -g -y                        # upstream cmux skills (apply to Panecho too)
```

Native session-resume supported for: Claude Code, Codex, Grok, OpenCode, Pi, Amp, Cursor CLI, Gemini, Antigravity, Rovo Dev, Hermes, Copilot, CodeBuddy, Factory, Qoder.

## Socket API (advanced)

The socket path is injected into every Panecho surface as `$CMUX_SOCKET_PATH`. Panecho keeps it at the XDG state path `~/.local/state/cmux/cmux.sock` (NOT the legacy upstream `/tmp/cmux.sock`); the live path is also written to `~/.local/state/cmux/last-socket-path`, which is what the `cmux` CLI auto-discovers. Unix socket, JSON-RPC v2 — use for tight loops where subprocess spawn cost matters; otherwise prefer the CLI. See "Connecting to the Socket (Auth)" above for the in-surface vs. external (`--password` / `CMUX_SOCKET_PASSWORD`) auth model.

```bash
echo '{"id":"1","method":"workspace.list","params":{}}' | nc -U "$CMUX_SOCKET_PATH"
```

Method prefixes: `system.*`, `window.*`, `workspace.*`, `pane.*`, `surface.*`, `notification.*`, `browser.*`. Enumerate available methods in the current build with `cmux capabilities --json`.

Access modes: `cmuxOnly` (default — only Panecho-spawned processes), `automation` (any local process), `password`, `allowAll` (unsafe). If a write to the socket fails with `Failed to write to socket (Broken pipe, errno 32)`, you're an unauthenticated external process — run from inside a Panecho surface (auto-auth) or pass `--password` / set `CMUX_SOCKET_PASSWORD` (see "Connecting to the Socket (Auth)").

## Critical Rules — Non-Disruptive Automation

These rules prevent agents from yanking the user's focus:

1. **Anchor to `CMUX_WORKSPACE_ID`.** Never assume the visually focused workspace is the target.
2. **Never call focus-changing verbs speculatively.** `select-workspace`, `focus-pane`, `focus-panel` only on explicit user request. Pass `--focus false` whenever available.
3. **Build layout additively in one call.** `cmux new-pane --type … --focus false` beats create-then-move-then-focus chains.
4. **Right-side helper pane pattern.** Reuse an existing non-caller helper pane if present; otherwise create exactly one right-side pane.
5. **Never send input to surfaces you don't own.** Only target surfaces in the caller's workspace unless the user explicitly asks for cross-workspace routing.
6. **Check surface health before routing input** when UI state may be stale: `cmux surface-health`.
7. **Respect privacy mode.** Treat update/analytics/cloud/remote-auth failures as expected, not as bugs to retry around.

## Common Pitfalls

- **Socket failures from external processes** → `Failed to write to socket (Broken pipe, errno 32)` means unauthenticated under default `cmuxOnly`; run inside a Panecho surface (auto-auth) or pass `--password` / `CMUX_SOCKET_PASSWORD`.
- **macOS only.** No Linux/Windows port. Apple Silicon (arm64) builds.
- **WKWebView ≠ CDP.** Don't expect Playwright-equivalent network mocking or viewport emulation.
- **Privacy mode ≠ no network.** Browser/SSH/child processes still reach the network; only the app's own telemetry/update `URLSession` calls are blocked.
- **Resume strips sensitive env vars.** Re-inject tokens at resume time if the agent needs them.
- **Skills snapshot at app start.** Edits to skill files require a restart of the consuming agent.
- **Legacy v1 socket payloads (`{"command":...}`) rejected.** Use v2 JSON-RPC only.
- **Don't `cat ~/.cmuxterm/*-hook-sessions.json`** expecting secrets — they're scrubbed. Look there for session/surface mappings only.

## Reference: Full CLI Help

For any command, `cmux <cmd> --help` is authoritative. Use `cmux capabilities --json` to enumerate available socket methods in the current build.

## Keyboard Shortcuts (most-used)

Workspaces: ⌘N new, ⌘1–8 jump, ⌃⌘[ / ⌃⌘] prev/next, ⌘⇧W close, ⌘B sidebar.
Surfaces: ⌘T new, ⌘⇧[ / ⌘⇧] prev/next, ⌘W close, ⌃1–8 jump.
Splits: ⌘D right, ⌘⇧D down, ⌥⌘D browser right, ⌥⌘←→↑↓ focus directional, ⌘⇧↵ zoom.
Browser: ⌘⇧L open, ⌘L address bar, ⌘[/⌘] back/forward, ⌥⌘I devtools.
App: ⌘, settings, ⌘⇧, reload-config, ⌘⇧P palette, ⌘⇧O restore session, ⌃⌥⌘. system-wide show/hide.
