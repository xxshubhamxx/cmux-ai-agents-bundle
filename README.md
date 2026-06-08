# Panecho AI Agents Bundle

Free, MIT-licensed kit for developers who run multiple AI coding agents inside **[Panecho](https://github.com/xxshubhamxx/cmux-panecho)** — the privacy-hardened fork of [cmux](https://github.com/manaflow-ai/cmux), the native macOS terminal built for parallel AI workflows.

If you have ever opened five Panecho workspaces, lost track of which agent owns which surface, and accidentally stolen focus from the user three times in one minute, this bundle is for you.

> **What is Panecho?** A drop-in fork of cmux that ships with telemetry, analytics, crash reporting, and auto-update checks **disabled by default**, plus a fail-closed outbound-egress guard. Same app, same `cmux` CLI, same socket API — just no surprise outbound traffic when you launch it. Built for environments where data privacy is a hard requirement.

---

## What's inside

| Path | What it is |
|---|---|
| [`.claude-plugin/`](./.claude-plugin) | Plugin + marketplace manifests. This repo **is** a Claude Code marketplace — `/plugin marketplace add` reads these. |
| [`skills/panecho/`](./skills/panecho) | The installable **Panecho skill** — teaches Claude Code (or any agent) to drive Panecho from the CLI or socket: workspaces, panes, surfaces, browser automation, notifications, sidebar metadata, the non-disruptive focus rules, and the privacy-mode caveats agents need to know. |
| [`awesome-panecho/`](./awesome-panecho) | Curated index of every Panecho + upstream cmux resource — releases, docs, skills, agents. The bookmark you keep open. |
| [`panecho-recipes/`](./panecho-recipes) | 23 numbered, copy-paste recipes (CLI + Python + Bash) for the socket API: notify-on-build-fail, flash-on-test-pass, screenshot a browser surface, run three agents on one PR, and more. |

> Panecho ships the **same `cmux` CLI binary** as upstream, so every command and recipe here works verbatim — `cmux identify`, `cmux new-pane`, the `CMUX_*` env vars, the JSON-RPC socket. Only the app, bundle id (`io.panecho.app`), and URL scheme (`panecho`) are rebranded.

---

## Set up in Claude Code

This repo is a Claude Code **plugin marketplace**, so installing the skill is two commands inside Claude Code:

```text
/plugin marketplace add xxshubhamxx/cmux-ai-agents-bundle
/plugin install panecho@panecho
```

Done. Claude Code loads the `panecho` skill and **auto-activates** it whenever you mention Panecho or cmux, or ask Claude to drive terminal layout, browser panes, notifications, or sidebar status. Verify and manage it with:

```text
/plugin                       # the panecho plugin shows as enabled
```

Pull future updates with `/plugin marketplace update` (then `/plugin install panecho@panecho` if a new version published).

### Alternatives (no plugin)

Prefer to wire the skill in by hand, or use another agent? The skill is a single self-contained file at [`skills/panecho/SKILL.md`](./skills/panecho/SKILL.md).

```bash
git clone https://github.com/xxshubhamxx/cmux-ai-agents-bundle.git

# Personal skill — available in every project:
mkdir -p ~/.claude/skills/panecho
cp cmux-ai-agents-bundle/skills/panecho/SKILL.md ~/.claude/skills/panecho/SKILL.md

# OR project skill — commit it so your whole team gets it:
mkdir -p .claude/skills/panecho
cp cmux-ai-agents-bundle/skills/panecho/SKILL.md .claude/skills/panecho/SKILL.md
```

Other agents that read a `skills/` directory (Hermes, etc.): drop `skills/panecho/SKILL.md` into their skills folder. The upstream cmux skills also work against Panecho (same CLI/socket): `npx skills add manaflow-ai/cmux -g -y` — this bundle's skill adds the privacy-mode rules the upstream one doesn't cover.

> After adding a skill by hand, restart Claude Code (or run `/reload-plugins`) so it's picked up.

---

## Install Panecho itself

There is no Homebrew cask — Panecho is a signed + notarized release artifact from the fork:

```bash
# 1. Download the latest Panecho.dmg (or panecho-macos.zip) from:
#    https://github.com/xxshubhamxx/cmux-panecho/releases/latest

# 2. From the DMG: drag Panecho.app to /Applications.
#    Or from the zip:
ditto -x -k ~/Downloads/panecho-macos.zip /tmp/panecho && \
  ditto /tmp/panecho/Panecho.app /Applications/Panecho.app

# 3. Symlink the CLI (the binary is still named `cmux`)
sudo ln -sf "/Applications/Panecho.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux

cmux version    # -> cmux 0.64.14 (94) [<commit>]
```

> Requires macOS 14.0+ (Apple Silicon, arm64). The current release (`panecho-v0.64.14`) is Developer ID-signed (Browserstack Inc), notarized, and stapled, so Gatekeeper opens it without the "unidentified developer" block.

---

## Why this exists

cmux is powerful but the docs are deep — 200+ socket methods, a sidebar metadata system, an embedded WKWebView browser, 100+ keyboard shortcuts, and a set of non-obvious "don't steal the user's focus" rules you only learn by breaking them.

Panecho adds one more dimension agents must respect: **privacy mode changes runtime behavior.** Update checks, analytics, crash reporting, and remote auth/cloud calls are gated off by default, and a fail-closed guard blocks non-loopback `URLSession` traffic. An agent that assumes those network paths are live will get errors instead of silent success — so the skill documents exactly what is disabled.

This repo collapses all of that into:

- one skill your agents can actually load (one command via the plugin marketplace),
- one recipes folder you can `grep` into,
- one awesome-list to find everything else.

Stars and PRs welcome.

---

## Privacy mode — what agents should expect

Panecho's privacy mode is **on by default**. In practice:

- **Disabled, returns a clear error/no-op:** automatic + manual update checks (Sparkle), PostHog analytics, Sentry crash reporting, remote auth sign-in, cloud/VM provisioning, remote-daemon downloads.
- **Still works (user-initiated):** browser tabs you open, SSH workspaces you start, local socket control, anything you explicitly drive.
- **Not a full network sandbox:** the egress guard covers the default `URLSession` registry. Child processes (your shells, `ssh`, `ghostty`), WKWebView page loads, and raw sockets are out of its scope by design. For provable network isolation, pair Panecho with an OS-level egress firewall.

See [`skills/panecho/SKILL.md`](./skills/panecho/SKILL.md#privacy-mode--what-changes) for the agent-facing version of these rules.

---

## License

MIT. Use it, fork it, ship it inside your own tools. A link back is appreciated, not required.

## Credits

Adapted for **Panecho** (privacy fork) from the original **cmux AI Agents Bundle** built by [pawel-cell](https://github.com/pawel-cell) for [David Ondrej](https://davidondrej.com). cmux is built by [Manaflow](https://manaflow.com); Panecho is an independent privacy-hardened fork. This repo is unaffiliated with Manaflow, David Ondrej, or pawel-cell — a community companion kit that preserves the original's MIT terms and attribution.
