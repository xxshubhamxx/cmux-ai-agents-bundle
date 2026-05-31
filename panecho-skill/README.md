# panecho-skill

A single drop-in skill that teaches any AI coding agent how to drive **Panecho** — the privacy-hardened fork of cmux, a native macOS terminal for parallel AI agents — through its CLI (`cmux`) and Unix-socket JSON-RPC API (`/tmp/cmux.sock`).

## Install

For agents that read `skills/` directories (Claude Code, Hermes, etc.), copy or symlink `SKILL.md` into your agent's skills folder:

```bash
# Claude Code
mkdir -p ~/.claude/skills/panecho
cp SKILL.md ~/.claude/skills/panecho/SKILL.md

# Hermes
mkdir -p ~/.hermes/skills/panecho
cp SKILL.md ~/.hermes/skills/panecho/SKILL.md
```

Or, project-local:

```bash
mkdir -p .claude/skills/panecho
cp SKILL.md .claude/skills/panecho/SKILL.md
```

The upstream cmux skills also work against Panecho (same CLI/socket) and can be installed with:

```bash
npx skills add manaflow-ai/cmux -g -y
```

This Panecho-tuned skill adds the privacy-mode rules the upstream skill doesn't cover.

## What's in it

- Topology primitives (workspaces / panes / surfaces) and short-ref handles.
- Environment detection (`CMUX_WORKSPACE_ID`, `CMUX_SOCKET_PATH`).
- CLI cheats for creating panes, moving surfaces, sending input.
- Browser automation pattern (open → wait → snapshot → act).
- Notifications, status, progress, sidebar flashes.
- Socket JSON-RPC v2 entry point and access-mode pitfalls.
- The **non-disruptive automation rules** that prevent agents from stealing the user's focus.
- **Privacy-mode rules** — what's disabled by default and how agents should handle the resulting errors.

## When the agent should load it

- The user mentions Panecho (or cmux).
- The agent is being asked to control terminal layout from inside an automation loop.
- The agent needs to drive a browser surface on macOS.
- The agent wants to send notifications / flashes to the sidebar.
- The agent is being wired into Panecho/cmux hooks.

## Requires

- Panecho (macOS 14.0+, Apple Silicon) — install from [the fork's releases](https://github.com/xxshubhamxx/cmux-panecho/releases/latest)
- macOS 14.0+

## License

MIT. Same as the parent bundle.
