# Panecho AI Agents Bundle

Free, MIT-licensed kit for developers who run multiple AI coding agents inside **[Panecho](https://github.com/xxshubhamxx/cmux-panecho)** — the privacy-hardened fork of [cmux](https://github.com/manaflow-ai/cmux), the native macOS terminal built for parallel AI workflows.

If you have ever opened five Panecho workspaces, lost track of which agent owns which surface, and accidentally stolen focus from the user three times in one minute, this bundle is for you.

> **What is Panecho?** A drop-in fork of cmux that ships with telemetry, analytics, crash reporting, and auto-update checks **disabled by default**, plus a fail-closed outbound-egress guard. Same app, same `cmux` CLI, same socket API — just no surprise outbound traffic when you launch it. Built for environments where data privacy is a hard requirement.

---

## What's inside

| Folder | What it is |
|---|---|
| [`awesome-panecho/`](./awesome-panecho) | Curated index of every Panecho + upstream cmux resource — releases, docs, skills, agents. The bookmark you keep open. |
| [`panecho-skill/`](./panecho-skill) | Drop-in skill that teaches any AI coding agent how to drive Panecho from the CLI or socket — workspaces, panes, surfaces, browser automation, notifications, the non-disruptive focus rules, and the privacy-mode caveats agents need to know. |
| [`panecho-recipes/`](./panecho-recipes) | 20 numbered, copy-paste recipes (CLI + Python + Bash) for the socket API: notify-on-build-fail, flash-on-test-pass, screenshot a browser surface, run three agents on one PR, and more. |

> Panecho ships the **same `cmux` CLI binary** as upstream, so every command and recipe here works verbatim — `cmux identify`, `cmux new-pane`, `/tmp/cmux.sock`, the `CMUX_*` env vars. Only the app, bundle id (`io.panecho.app`), and URL scheme (`panecho`) are rebranded.

---

## Quick start

```bash
git clone https://github.com/xxshubhamxx/cmux-ai-agents-bundle.git
cd cmux-ai-agents-bundle

# Wire the Panecho skill into Claude Code (or your agent of choice)
mkdir -p ~/.claude/skills/panecho
cp panecho-skill/SKILL.md ~/.claude/skills/panecho/SKILL.md

# Browse the recipes
ls panecho-recipes/
```

### Install Panecho itself

There is no Homebrew cask — Panecho is distributed as a signed-on-build release artifact from the fork:

```bash
# 1. Download the latest Panecho.app from the releases page
#    https://github.com/xxshubhamxx/cmux-panecho/releases/latest
#    (asset: panecho-macos.zip)

# 2. Unzip and install
ditto -x -k ~/Downloads/panecho-macos.zip /tmp/panecho && \
  ditto /tmp/panecho/Panecho.app /Applications/Panecho.app

# 3. Symlink the CLI (the binary is still named `cmux`)
sudo ln -sf "/Applications/Panecho.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux

cmux version    # -> cmux 0.64.x (…) [<commit>]
```

> Requires macOS 14.0+ (Apple Silicon, arm64). Or, from a checked-out fork: `./scripts/install-panecho.sh`.

---

## Why this exists

cmux is powerful but the docs are deep — 60+ socket methods, a sidebar metadata system, an embedded WKWebView browser, 100+ keyboard shortcuts, and a set of non-obvious "don't steal the user's focus" rules you only learn by breaking them.

Panecho adds one more dimension agents must respect: **privacy mode changes runtime behavior.** Update checks, analytics, crash reporting, and remote auth/cloud calls are gated off by default, and a fail-closed guard blocks non-loopback `URLSession` traffic. An agent that assumes those network paths are live will get errors instead of silent success — so the skill documents exactly what is disabled.

This repo collapses all of that into:

- one skill your agents can actually load,
- one recipes folder you can `grep` into,
- one awesome-list to find everything else.

Stars and PRs welcome.

---

## Privacy mode — what agents should expect

Panecho's privacy mode is **on by default**. In practice:

- **Disabled, returns a clear error/no-op:** automatic + manual update checks (Sparkle), PostHog analytics, Sentry crash reporting, remote auth sign-in, cloud/VM provisioning, remote-daemon downloads.
- **Still works (user-initiated):** browser tabs you open, SSH workspaces you start, local socket control, anything you explicitly drive.
- **Not a full network sandbox:** the egress guard covers the default `URLSession` registry. Child processes (your shells, `ssh`, `ghostty`), WKWebView page loads, and raw sockets are out of its scope by design. For provable network isolation, pair Panecho with an OS-level egress firewall.

See [`panecho-skill/SKILL.md`](./panecho-skill/SKILL.md#privacy-mode--what-changes) for the agent-facing version of these rules.

---

## License

MIT. Use it, fork it, ship it inside your own tools. A link back is appreciated, not required.

## Credits

Adapted for **Panecho** (privacy fork) from the original **cmux AI Agents Bundle** built by [pawel-cell](https://github.com/pawel-cell) for [David Ondrej](https://davidondrej.com). cmux is built by [Manaflow](https://manaflow.com); Panecho is an independent privacy-hardened fork. This repo is unaffiliated with Manaflow, David Ondrej, or pawel-cell — a community companion kit that preserves the original's MIT terms and attribution.
