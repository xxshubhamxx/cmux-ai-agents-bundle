# cmux Skills Pack

Five community skills that extend cmux's official skills system. They teach AI coding agents (Claude Code, Codex, Hermes, Copilot, etc.) how to use cmux for specific workflows.

## Install

```bash
# Via Vercel's skills CLI (works for Claude Code, Codex, OpenCode, Hermes, etc.)
npx skills add pawel-cell/cmux-ai-agents-bundle --path cmux-skills-pack -g -y

# Or specific skill only
npx skills add pawel-cell/cmux-ai-agents-bundle --path cmux-skills-pack --skill cmux-pr-review -g -y

# Or copy them yourself
cp -r cmux-skills-pack/*  ~/.claude/skills/    # Claude Code
cp -r cmux-skills-pack/*  ~/.codex/skills/     # Codex
cp -r cmux-skills-pack/*  ~/.hermes/skills/    # Hermes
```

## What's in the pack

| Skill | Purpose |
|---|---|
| [`cmux-pr-review`](./cmux-pr-review) | Spawn 3 agents in parallel to review a PR (code, security, tests), then aggregate verdicts in a 4th surface. |
| [`cmux-test-while-coding`](./cmux-test-while-coding) | Side-by-side layout: code on the left, watch-mode test runner on the right, flash + notify when tests change state. |
| [`cmux-deploy-watcher`](./cmux-deploy-watcher) | Tail a deploy and turn its status into sidebar pills + ring flashes (no more refreshing Vercel/CI tabs). |
| [`cmux-debugger`](./cmux-debugger) | 4-pane debug layout — REPL, logs, code, embedded browser — connected so a fix in code flashes the browser. |
| [`cmux-research-trio`](./cmux-research-trio) | Three browser surfaces (docs, blog, repo) plus a notes terminal — for "read 3 sources and write a synthesis" research jobs. |

## How to invoke from your agent

Each skill ships as `<name>/SKILL.md`. After installing them, any cmux-aware agent that reads its skills directory will discover and use them automatically when the user says things like:

- "Review PR #123 with three agents" → loads `cmux-pr-review`
- "Set up test-while-coding for this file" → loads `cmux-test-while-coding`
- "Watch the Vercel deploy" → loads `cmux-deploy-watcher`

For agents that don't auto-load, point them at the skill explicitly:

> Read `~/.claude/skills/cmux-pr-review/SKILL.md` and follow it.

## Pre-reqs

These skills assume:

- cmux v0.64.0 or newer
- Your agent reads cmux's [official skills](https://cmux.com/docs/skills) (`npx skills add manaflow-ai/cmux -g -y`) — they build on top of `cmux`, `cmux-workspace`, and `cmux-browser`.
- The non-disruptive automation rules from `cmux-workspace` apply: scope to `CMUX_WORKSPACE_ID`, never steal focus, prefer `--focus false`.

## License

MIT.
