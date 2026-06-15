# Awesome Panecho

> A curated list of everything around **[Panecho](https://github.com/xxshubhamxx/cmux-panecho)** — the privacy-hardened fork of [cmux](https://github.com/manaflow-ai/cmux), the native macOS terminal built for running multiple AI coding agents in parallel.

Panecho is a drop-in fork: same `cmux` CLI, same socket API, telemetry/analytics/crash/auto-update **disabled by default**. Most upstream cmux docs and skills below apply unchanged — they're included here because they're genuinely useful and Panecho tracks upstream closely.

Contributions welcome — open a PR or an issue.

---

## Contents

- [Panecho (this fork)](#panecho-this-fork)
- [Install Panecho](#install-panecho)
- [Privacy](#privacy)
- [Upstream cmux — official](#upstream-cmux--official)
- [Docs in the CLI](#docs-in-the-cli)
- [Skills](#skills)
- [Supported AI agents](#supported-ai-agents)
- [Hooks & integrations](#hooks--integrations)
- [Browser automation](#browser-automation)
- [Configuration](#configuration)
- [Articles & write-ups](#articles--write-ups)
- [Videos & demos](#videos--demos)
- [Community](#community)
- [Companion tools](#companion-tools)
- [In this bundle](#in-this-bundle)

---

## Panecho (this fork)

- [GitHub: xxshubhamxx/cmux-panecho](https://github.com/xxshubhamxx/cmux-panecho) — the Panecho fork source
- [Latest release](https://github.com/xxshubhamxx/cmux-panecho/releases/latest) — current: [`panecho-v0.64.15`](https://github.com/xxshubhamxx/cmux-panecho/releases/tag/panecho-v0.64.15); `panecho-macos.zip` (Apple Silicon, arm64), Developer ID signed (Browserstack Inc, Team `YQ5FZQ855D`), notarized + stapled
- [All releases](https://github.com/xxshubhamxx/cmux-panecho/releases) — versioned (`panecho-vX.Y.Z`) + rolling `panecho-nightly`
- Identity: app `Panecho.app`, bundle id `io.panecho.app`, URL scheme `panecho`
- CLI: still `cmux` (drop-in compatible) — `cmux version` reports the upstream base version + Panecho commit

## Install Panecho

No Homebrew cask — install from the fork's release artifact:

```bash
# Download panecho-macos.zip from https://github.com/xxshubhamxx/cmux-panecho/releases/latest
ditto -x -k ~/Downloads/panecho-macos.zip /tmp/panecho
ditto /tmp/panecho/Panecho.app /Applications/Panecho.app
sudo ln -sf "/Applications/Panecho.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux
cmux version
```

Or, from a checked-out fork: `./scripts/install-panecho.sh`. Requires macOS 14.0+.

## Privacy

The reason Panecho exists. By default:

- **Off:** auto-update checks (Sparkle, no feed URL), PostHog analytics (SDK not linked), Sentry crash reporting (SDK not linked), remote auth sign-in, cloud/VM provisioning, remote-daemon downloads.
- **Fail-closed:** a `URLSession` egress guard rejects non-loopback HTTP(S)/WS traffic from the app itself.
- **Out of scope by design:** WKWebView page loads, child processes (`ssh`, `ghostty`, your shells), raw sockets. Privacy mode is not a full network sandbox — pair with an OS egress firewall for provable isolation.
- Verify a build yourself: `otool -L Panecho.app/Contents/MacOS/cmux | grep -i 'sentry\|posthog'` (expect nothing) and `PlistBuddy -c 'Print :SUFeedURL' Panecho.app/Contents/Info.plist` (expect missing).

## Upstream cmux — official

Panecho is based on cmux; these upstream resources describe the shared engine and behavior.

- [cmux.com](https://cmux.com) — homepage
- [cmux.com/docs](https://cmux.com/docs) — getting started
- [cmux.com/docs/configuration](https://cmux.com/docs/configuration) — full `cmux.json` schema reference
- [cmux.com/docs/api](https://cmux.com/docs/api) — CLI and socket API reference
- [cmux.com/docs/notifications](https://cmux.com/docs/notifications) — notification system, OSC sequences, hooks
- [cmux.com/docs/ssh](https://cmux.com/docs/ssh) — SSH workspaces and browser routing
- [cmux.com/docs/session-restore](https://cmux.com/docs/session-restore) — session restore, supported agents, resume commands
- [cmux.com/docs/skills](https://cmux.com/docs/skills) — skills system
- [cmux.com/docs/custom-commands](https://cmux.com/docs/custom-commands) — actions, layouts, surface definitions
- [GitHub: manaflow-ai/cmux](https://github.com/manaflow-ai/cmux) — upstream source repo
- [GitHub: CHANGELOG.md](https://raw.githubusercontent.com/manaflow-ai/cmux/main/CHANGELOG.md) — full version history
- [DeepWiki: manaflow-ai/cmux](https://deepwiki.com/manaflow-ai/cmux) — auto-generated architecture overview
- [Mintlify socket-api reference](https://manaflow-ai-cmux.mintlify.app/automation/socket-api) — full JSON-RPC method list

## Docs in the CLI

Panecho ships canonical docs offline. `cmux docs <topic>` prints the web URL, raw GitHub resources (with ready-to-run `curl` commands), and the most useful CLI commands for that topic — no running app or socket required, no auth needed. Run `cmux docs` with no topic for the list.

| Topic | What it covers | Try |
|---|---|---|
| `cmux docs api` | CLI/socket API, handle model, windows, workspaces, panes, surfaces | `cmux docs api` |
| `cmux docs browser` | Browser-panel automation and snapshot-driven web interaction | `cmux docs browser` |
| `cmux docs agents` | Agent hook integrations, Feed approvals, notifications, session restore | `cmux docs agents` |
| `cmux docs settings` | `cmux.json` locations, schema, reload flow | `cmux docs settings` |
| `cmux docs sidebars` | Vibe-coded custom SwiftUI-style sidebars in `~/.config/cmux/sidebars/` (beta) | `cmux docs sidebars` |
| `cmux docs dock` | Custom right-sidebar terminal controls from `.cmux/dock.json` | `cmux docs dock` |
| `cmux docs shortcuts` | cmux-owned keyboard shortcuts and two-step chord syntax | `cmux docs shortcuts` |

## Skills

Install upstream skills (they apply to Panecho too): `npx skills add manaflow-ai/cmux -g -y`. Or install this bundle's Panecho-tuned skill ([`../skills/panecho`](../skills/panecho/SKILL.md)) — in Claude Code: `/plugin marketplace add xxshubhamxx/cmux-ai-agents-bundle` then `/plugin install panecho@panecho`. It adds the privacy-mode rules the upstream skill omits.

- [cmux Core](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux/SKILL.md) — windows, workspaces, panes, surfaces, focus, moves
- [cmux Workspace](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-workspace/SKILL.md) — caller-workspace-scoped automation, non-disruptive rules
- [cmux Settings](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-settings/SKILL.md) — safe `cmux.json` edits
- [cmux Customization](https://github.com/manaflow-ai/cmux/tree/main/skills/cmux-customization) — actions, layouts, tab buttons
- [cmux Diagnostics](https://github.com/manaflow-ai/cmux/tree/main/skills/cmux-diagnostics) — CLI/socket/hooks health checks
- [cmux Browser](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-browser/SKILL.md) — WKWebView browser automation
- [cmux Markdown Viewer](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-markdown/SKILL.md) — live-watching markdown panel

## Supported AI agents

Panecho ships the same first-class session-restore + hook integration as cmux for these:

| Agent | Resume command | Hook feed |
|---|---|---|
| [Claude Code](https://docs.anthropic.com/claude-code) | `claude --resume <id>` | `PermissionRequest` |
| [Codex](https://github.com/openai/codex) | `codex resume <id>` | `PreToolUse`, `PermissionRequest` |
| [Grok / Grok Build CLI](https://x.ai) | `grok -r <id>` | `PreToolUse` |
| [OpenCode](https://github.com/sst/opencode) | `opencode --session <id>` | plugin event bus |
| [Pi](https://pi.ai) | `pi --session <id>` | — |
| [Amp](https://ampcode.com) | `amp threads continue <id>` | — |
| [Cursor CLI](https://cursor.com) | `cursor-agent --resume <id>` | `beforeShellExecution` |
| [Gemini](https://gemini.google.com) | `gemini --resume <id>` | `PreToolUse` |
| [Antigravity CLI](https://antigravity.google) | `agy --conversation <id>` | `PreToolUse`, `PostToolUse` |
| [Rovo Dev](https://www.atlassian.com/software/rovo) | `acli rovodev run --restore <id>` | — |
| [Hermes Agent](https://hermes-agent.nousresearch.com) | `hermes --resume <id>` | pre/post tool, approval |
| [Copilot CLI](https://github.com/features/copilot) | `copilot --resume <id>` | `PreToolUse` |
| [CodeBuddy](https://copilot.tencent.com) | `codebuddy --resume <id>` | `PreToolUse` |
| [Factory (droid)](https://factory.ai) | `droid --resume <id>` | `PreToolUse` |
| [Qoder](https://qoder.com) | `qodercli --resume <id>` | `PreToolUse` |

Install all detected hooks at once: `cmux hooks setup`

## Hooks & integrations

- [Official OSC 9 / 99 / 777 notification protocol](https://cmux.com/docs/notifications)
- [cmux notify CLI](https://cmux.com/docs/api) — `cmux notify --title "..." --body "..."`
- [Claude Code hook example](https://cmux.com/docs/notifications#manual-claude-code-hook)
- [`../skills/panecho/`](../skills/panecho/SKILL.md) — drop-in skill that wires any agent into Panecho (install via `/plugin marketplace add xxshubhamxx/cmux-ai-agents-bundle`)

## Browser automation

Panecho includes the same embedded WKWebView browser with a scriptable API (ported from agent-browser).

- [Browser commands reference](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-browser/references/commands.md)
- [Browser skill](https://raw.githubusercontent.com/manaflow-ai/cmux/main/skills/cmux-browser/SKILL.md)
- Known WKWebView limitations (return `not_supported`): viewport emulation, offline mode, trace recording, network interception, raw input injection
- Privacy note: WKWebView page loads are **not** gated by the egress guard — browser surfaces reach the network normally.

## Configuration

- [cmux.json schema](https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json) (Panecho tracks the upstream schema)
- Config locations:
  - `~/.config/cmux/cmux.json` (canonical — path keeps the `cmux` name for drop-in compatibility)
  - `~/.config/ghostty/config` (terminal rendering, font, theme)
  - `.cmux/cmux.json` (project-local override)
- Reload without restart: `cmux reload-config` or `⌘⇧,`

## Articles & write-ups

These cover upstream cmux; the mechanics apply to Panecho.

- [Teaching Coding Agents to Drive cmux](https://bounds.dev) — Jesse Bounds
- [cmux: the terminal built for AI coding agents](https://dev.to/neuraldownload/cmux-the-terminal-built-for-ai-coding-agents-3l7h) — DEV.to overview
- [cmux: native macOS terminal for parallel AI coding agents](https://dev.to/arshtechpro/cmux-the-native-macos-terminal-built-for-running-ai-coding-agents-in-parallel-52il) — DEV.to technical guide
- [HN: Teaching Coding Agents to Drive Cmux](https://news.ycombinator.com/item?id=47258502) — discussion thread

## Videos & demos

- [David Ondrej — cmux walkthrough](https://youtube.com/@davidondrej) — full setup + 5-agent workflow demo
- *Open a PR to add Panecho-specific demos*

## Community

- [Panecho issues](https://github.com/xxshubhamxx/cmux-panecho/issues) — fork bug reports, feature requests
- [Upstream cmux Discussions](https://github.com/manaflow-ai/cmux/discussions)
- [Upstream cmux Issues](https://github.com/manaflow-ai/cmux/issues)

## Companion tools

Useful next to Panecho:

- [Ghostty](https://ghostty.org) — the rendering engine cmux/Panecho is built on (use its config for fonts/theme)
- [Claude Code](https://docs.anthropic.com/claude-code) — Anthropic's terminal agent
- [Codex CLI](https://github.com/openai/codex) — OpenAI's terminal agent
- [Hermes Agent](https://hermes-agent.nousresearch.com) — open-source agent runtime with cmux integration
- [npx skills](https://www.npmjs.com/package/skills) — Vercel's skills installer
- [tmux](https://github.com/tmux/tmux) — the OG terminal multiplexer (cmux is the GUI-native take)

## In this bundle

- **Claude Code plugin marketplace** — this repo *is* a marketplace. Add it once, then install the skill:
  ```
  /plugin marketplace add xxshubhamxx/cmux-ai-agents-bundle
  /plugin install panecho@panecho
  ```
- [`../skills/panecho/`](../skills/panecho/SKILL.md) — drop-in skill that teaches any agent to drive Panecho (with privacy-mode rules)
- [`../panecho-recipes/`](../panecho-recipes) — 23 copy-paste socket-API + CLI snippets

---

Adapted for Panecho from the original Awesome cmux list. PRs welcome.
