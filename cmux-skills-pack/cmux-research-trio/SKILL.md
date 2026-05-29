---
name: cmux-research-trio
description: Three browser surfaces (docs, blog, repo) plus a notes terminal — for 'read three sources and write a synthesis' research jobs.
---

# cmux Research Trio

Use this skill when the user says "research X — open the docs, a blog, and the GitHub repo".

## What it does

Opens 3 embedded-browser surfaces side by side, each navigated to a different source, plus a 4th terminal surface for note-taking.

## Steps

```bash
WS="${CMUX_WORKSPACE_ID:?inside cmux}"
TOPIC="$1"        # e.g. "DSPy"
DOCS_URL="$2"
BLOG_URL="$3"
REPO_URL="$4"

# Right-side helper pane (re-use if present)
PANE_ID=$(cmux list-panes --workspace "$WS" --json \
  | jq -r --arg me "$CMUX_SURFACE_ID" '.result.panes | map(select((.surfaces // []) | map(.surface_ref) | index($me) | not)) | .[0].pane_ref // empty')
[ -z "$PANE_ID" ] && {
  cmux new-pane --workspace "$WS" --type terminal --direction right --focus false
  PANE_ID=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')
}

# 3 browser surfaces in that pane (will appear as tabs the user can flip)
cmux --json browser open "$DOCS_URL" --workspace "$WS"
cmux --json browser open "$BLOG_URL" --workspace "$WS"
cmux --json browser open "$REPO_URL" --workspace "$WS"

# Notes terminal — opens a markdown file in cmux's viewer
NOTES_FILE="$HOME/notes/research-${TOPIC// /-}-$(date +%Y%m%d).md"
mkdir -p "$(dirname "$NOTES_FILE")"
cat > "$NOTES_FILE" <<EOF
# Research: $TOPIC

Date: $(date)
Sources:
- $DOCS_URL
- $BLOG_URL
- $REPO_URL

## Notes

- 

## Synthesis (3 bullets)

- 

EOF

cmux markdown open "$NOTES_FILE" --workspace "$WS"
cmux notify --title "Research" --body "Trio ready for $TOPIC"
```

## Rules

- Use `--focus false` semantics implicitly via `markdown open` and `browser open` (they don't steal focus by default).
- Don't navigate the user's existing browser surfaces — always open NEW ones.
