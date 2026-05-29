# cmux AI Agents Bundle

Free, MIT-licensed kit for developers who run multiple AI coding agents inside [cmux](https://cmux.com) — the native macOS terminal built for parallel AI workflows.

If you have ever opened five cmux workspaces, lost track of which agent owns which surface, and accidentally stolen focus from the user three times in one minute, this bundle is for you.

> Companion to David Ondrej's [cmux walkthrough on YouTube](https://youtube.com/@davidondrej). Built and maintained at [davidondrej.com](https://davidondrej.com).

---

## What's inside

| Folder | What it is |
|---|---|
| [`awesome-cmux/`](./awesome-cmux) | Curated index of every cmux resource — docs, skills, agents, blog posts, demos. The bookmark you keep open. |
| [`cmux-hooks/`](./cmux-hooks) | Ready-to-run notification + session-resume hooks for 15 AI coding agents (Claude Code, Codex, Grok, Cursor, Gemini, Hermes, Copilot, Factory…). One `install.sh` detects what you have. |
| [`cmux-skills-pack/`](./cmux-skills-pack) | Five new skills your agents can use: parallel PR review, test-while-coding, deploy watcher, debugger split, research trio. Installs via `npx skills add`. |
| [`cmux-cheatsheet/`](./cmux-cheatsheet) | One-page cheat sheet: the 30 CLI commands and 50 shortcuts you actually use, plus the focus-stealing rules pinned on top. PDF-ready. |
| [`cmux-recipes/`](./cmux-recipes) | 20 numbered, copy-paste recipes (CLI + Python + Bash) for the socket API: notify-on-build-fail, flash-on-test-pass, screenshot a browser surface, run three agents on one PR, and more. |

---

## Quick start

```bash
git clone https://github.com/pawel-cell/cmux-ai-agents-bundle.git
cd cmux-ai-agents-bundle

# Install hooks for whichever agents you have installed
./cmux-hooks/install.sh

# Install the skills pack (so your agents learn the new workflows)
npx skills add pawel-cell/cmux-ai-agents-bundle --path cmux-skills-pack -g -y

# Read the cheat sheet
open cmux-cheatsheet/CHEATSHEET.md
```

> Requires cmux v0.64.0 or newer. Install: `brew tap manaflow-ai/cmux && brew install --cask cmux`

---

## Why this exists

cmux is powerful but the docs are deep. There are 60+ socket methods, 7 skills, 14+ supported agents, 100+ keyboard shortcuts, and a set of non-obvious "don't steal the user's focus" rules that you only learn by breaking them.

This repo collapses that into:

- one cheat sheet,
- one hooks installer,
- one skills pack,
- one recipes folder you can `grep` into,
- one awesome-list to find everything else.

Stars and PRs welcome.

---

## Get the rest

This is the public, free version. The full **cmux AI Agents Bundle** also includes:

- the printable PDF cheat sheet (designed, not just markdown rendered),
- a 5-day email walkthrough that teaches one skill per day,
- the private "non-disruptive automation" playbook,
- bonus templates: PR-review prompt, debugger-split prompt, deploy-watcher config.

→ **Get it free at [davidondrej.com](https://davidondrej.com)**

---

## License

MIT. Use it, fork it, ship it inside your own tools. A link back is appreciated, not required.

## Credits

Built by [pawel-cell](https://github.com/pawel-cell) for [David Ondrej](https://davidondrej.com). cmux is built by [Manaflow](https://manaflow.com). This repo is unaffiliated with Manaflow — just a fan-made companion kit.
