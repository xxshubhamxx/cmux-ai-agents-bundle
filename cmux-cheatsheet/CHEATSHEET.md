# cmux Cheat Sheet

> One page. The 30 CLI commands and 50 shortcuts you actually use, plus the focus-stealing rules pinned on top. Print it, pin it.

cmux version: v0.64.10 (May 2026). macOS only.

---

## ⚠️ Read this first — the 5 non-disruptive rules

These come straight from the official `cmux-workspace` skill. Break them and you steal focus from a human user every time.

1. **Anchor to `CMUX_WORKSPACE_ID`.** The visually-focused workspace is *not* necessarily yours. Read your env var.
2. **Never call focus-changing verbs speculatively.** `select-workspace`, `focus-pane`, `focus-panel`, `focus-surface` are user-affecting actions. Only call on explicit user request.
3. **Use `--focus false` everywhere it exists.** `new-pane`, `move-surface`, `new-surface`, `cmux ssh` — they all support it.
4. **Build layout additively in one shot.** No create → move → focus chains.
5. **Never send input to surfaces you do not own.** Only target your own `CMUX_WORKSPACE_ID` surfaces unless the user explicitly says otherwise.

---

## 🧭 Identify yourself first

```bash
cmux identify --json
# tells you your window_ref, workspace_ref, pane_ref, surface_ref
```

Inside any cmux-spawned terminal these env vars are pre-set:

```bash
$CMUX_WORKSPACE_ID    # workspace:2
$CMUX_SURFACE_ID      # surface:5
$CMUX_SOCKET_PATH     # /tmp/cmux.sock
$CMUX_PORT            # base port reserved for this workspace
```

---

## 🧱 The 30 CLI commands you'll actually use

### Topology

```bash
cmux list-windows
cmux list-workspaces                          # add --json for parsing
cmux list-panes --workspace "$CMUX_WORKSPACE_ID"
cmux list-surfaces --workspace "$CMUX_WORKSPACE_ID"
cmux tree                                      # full hierarchy in one shot
cmux top                                       # TUI Task Manager (0.64.0+)
```

### Create

```bash
cmux new-workspace --name "feature-x" --cwd /path/to/repo
cmux new-pane --workspace "$CMUX_WORKSPACE_ID" --type terminal --direction right --focus false
cmux new-surface --pane pane:1 --type terminal --focus false
cmux new-surface --pane pane:1 --type browser  --url https://localhost:3000 --focus false
cmux split-off --surface "$CMUX_SURFACE_ID" right     # focus-neutral
```

### Send / interact

```bash
cmux send-surface --surface surface:7 "npm test\n"
cmux send-key-surface --surface surface:7 enter
cmux send-key "ctrl+c"                         # to focused terminal
```

### Notify the user

```bash
cmux notify --title "Build done" --body "All tests passed"
cmux trigger-flash --surface "$CMUX_SURFACE_ID"
cmux set-status build "compiling" --icon hammer --color "#ff9500"
cmux set-progress 0.5 --label "Building..."
cmux log --level success "42/42 tests passed"
```

### Browser

```bash
cmux --json browser open https://example.com               # returns surface_ref
cmux browser surface:7 wait --load-state complete --timeout-ms 15000
cmux browser surface:7 snapshot --interactive
cmux browser surface:7 click e5
cmux browser surface:7 fill e1 "hello"
cmux browser surface:7 screenshot
```

### Settings & docs

```bash
cmux docs settings                             # docs URLs + schema + paths
cmux settings cmux-json                        # open cmux.json in editor
cmux reload-config                             # reload without restart (⌘⇧,)
cmux ping                                      # is the daemon alive?
cmux capabilities                              # list available socket methods
```

### Sessions

```bash
cmux hooks setup                               # install hooks for all detected agents
cmux restore-session                           # manual restore (⌘⇧O)
cmux ssh user@remote --name "dev box" --no-focus
```

---

## ⌨️ The 50 shortcuts you actually use

### Workspaces

| Shortcut | Action |
|---|---|
| `⌘N` | New workspace |
| `⌘1–8` | Jump to workspace 1–8 |
| `⌘9` | Jump to last workspace |
| `⌃⌘]` / `⌃⌘[` | Next / previous workspace |
| `⌘⇧W` | Close workspace |
| `⌘⇧R` | Rename workspace |
| `⌥⌘E` | Edit workspace description |
| `⌘B` | Toggle sidebar |
| `⌥⌘B` | Toggle right sidebar |
| `⌘O` | Open folder |
| `⌘P` | Go to workspace (switcher) |

### Surfaces (tabs inside a pane)

| Shortcut | Action |
|---|---|
| `⌘T` | New surface |
| `⌘⇧]` / `⌘⇧[` | Next / previous surface |
| `⌃Tab` / `⌃⇧Tab` | Next / previous surface |
| `⌃1–8` | Jump to surface 1–8 |
| `⌃9` | Jump to last surface |
| `⌘W` | Close surface |
| `⌘R` | Rename tab |
| `⌥⌘T` | Close other tabs in pane |
| `⌘⇧T` | Reopen last closed |
| `⌘⇧M` | Toggle terminal copy mode |
| `⌘⇧A` | Switch focus terminal ↔ text-box |

### Split panes

| Shortcut | Action |
|---|---|
| `⌘D` | Split right |
| `⌘⇧D` | Split down |
| `⌥⌘D` | Split browser right |
| `⌥⌘⇧D` | Split browser down |
| `⌥⌘← → ↑ ↓` | Focus pane directionally |
| `⌥⌘=` | Equalize split sizes |

### Browser

| Shortcut | Action |
|---|---|
| `⌘⇧L` | Open browser in split |
| `⌘L` | Focus address bar |
| `⌘[` / `⌘]` | Back / forward |
| `⌘R` | Reload |
| `⌥⌘I` | Toggle DevTools |
| `⌥⌘C` | Show JS console |
| `⌘⇧G` | Toggle React Grab |

### Notifications

| Shortcut | Action |
|---|---|
| `⌘I` | Show notifications panel |
| `⌘⇧U` | Jump to latest unread |
| `⌥⌘U` | Toggle unread on current |
| `⌃⌘U` | Mark oldest unread + jump next |

### App

| Shortcut | Action |
|---|---|
| `⌘⇧N` | New window |
| `⌘,` | Settings |
| `⌘⇧,` | Reload configuration |
| `⌃⌥⌘.` | Show / hide all cmux windows (system-wide) |
| `⌥⌘F` | Global search (system-wide) |
| `⌘⇧P` | Command palette |
| `⌘⇧O` | Reopen previous session |

---

## 🧪 Socket API quick reference

```bash
# Ping
echo '{"id":"1","method":"system.ping","params":{}}' | nc -U /tmp/cmux.sock

# Notify
echo '{"id":"2","method":"notification.create","params":{"title":"Hi","body":"From the socket"}}' | nc -U /tmp/cmux.sock

# List workspaces
echo '{"id":"3","method":"workspace.list","params":{}}' | nc -U /tmp/cmux.sock
```

Socket paths:

- Stable: `/tmp/cmux.sock`
- Nightly: `/tmp/cmux-nightly.sock`
- Override: `CMUX_SOCKET_PATH=/tmp/your-path.sock`

Access modes (`automation.socketControlMode` in `cmux.json`):

| Mode | What it allows |
|---|---|
| `off` | nothing |
| `cmuxOnly` (default) | only processes with cmux ancestry |
| `automation` | any process from your macOS user |
| `password` | needs `auth <password>` first |
| `allowAll` | anyone local — unsafe |

---

## 🩹 Common gotchas

- **"Failed to connect to socket"** → you're outside a cmux terminal and mode is `cmuxOnly`. Switch to `automation` mode in Settings, or run from inside a cmux pane.
- **Focus suddenly jumps** → you (or your agent) called a focus verb. Search your script for `focus-pane`, `focus-panel`, `focus-surface`, `select-workspace`.
- **Browser command returns `not_supported`** → it's a CDP-only API (viewport, network mocking, raw input). WKWebView doesn't support it.
- **Memory ballooning to 8 GB in a non-git folder** → upgrade to v0.64.9+ (git-search OOM fix).
- **`brew upgrade --cask cmux` doesn't update Nightly** → Nightly is a separate cask / bundle ID.

---

## 📎 More

- This cheat sheet lives at: <https://github.com/pawel-cell/cmux-ai-agents-bundle>
- Pretty PDF + 5-day walkthrough: <https://davidondrej.com>
- Official docs: <https://cmux.com/docs>
