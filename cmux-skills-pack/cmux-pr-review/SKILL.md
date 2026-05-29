---
name: cmux-pr-review
description: Run 3 AI agents in parallel against one PR (code review, security review, test coverage review) inside cmux. Builds a focus-neutral layout, sends each agent a scoped prompt, and aggregates verdicts in a 4th surface.
---

# cmux PR Review (Parallel)

Use this skill when the user says "review this PR with multiple agents" or "do a parallel code review of <PR url>".

## What it does

Builds a 4-surface workspace:

1. **code** — runs your reviewer agent against the diff for correctness, style, bugs
2. **security** — runs a reviewer focused on auth, secrets, injection, supply chain
3. **tests** — runs a reviewer focused on test coverage and edge cases
4. **verdict** — aggregates the three outputs into a single GO/NO-GO comment

All four are created focus-neutrally (`--focus false`) inside the caller's workspace. The user keeps their current focus.

## Steps

```bash
# 1. Anchor to the caller's workspace
WS="${CMUX_WORKSPACE_ID:?must run inside a cmux terminal}"

# 2. Pull the PR diff into a tmp file (set by the agent runner)
PR_URL="$1"
DIFF_FILE="/tmp/cmux-pr-review-${WS//[:]/_}.diff"
gh pr diff "$PR_URL" > "$DIFF_FILE"

# 3. Build 4 surfaces, all focus-neutral
cmux new-pane --workspace "$WS" --type terminal --direction right --focus false   # right pane
PANE_RIGHT=$(cmux list-panes --workspace "$WS" --json | jq -r '.result.panes[-1].pane_ref')

cmux new-surface --pane "$PANE_RIGHT" --type terminal --focus false   # code
cmux new-surface --pane "$PANE_RIGHT" --type terminal --focus false   # security
cmux new-surface --pane "$PANE_RIGHT" --type terminal --focus false   # tests
cmux new-surface --pane "$PANE_RIGHT" --type terminal --focus false   # verdict

# 4. Send each surface its scoped prompt (use send-surface so we don't yank focus)
SURFS=($(cmux list-pane-surfaces --pane "$PANE_RIGHT" --json | jq -r '.result.surfaces[-4:][].surface_ref'))

cmux send-surface --surface "${SURFS[0]}" "claude --resume <code-reviewer-id> 'Review $DIFF_FILE for correctness, style, bugs. Output PASS/FAIL + bullet list.'\n"
cmux send-surface --surface "${SURFS[1]}" "claude --resume <security-reviewer-id> 'Audit $DIFF_FILE for auth, secrets, injection, supply-chain risks.'\n"
cmux send-surface --surface "${SURFS[2]}" "claude --resume <tests-reviewer-id> 'Score test coverage of $DIFF_FILE. Missing edge cases?'\n"

# 5. Flash + notify so the user knows it's running (does NOT steal focus)
cmux trigger-flash --workspace "$WS"
cmux notify --title "PR Review" --body "3 agents reviewing $PR_URL"
```

## Aggregation step (run after the three finish)

The verdict surface reads the three sibling surfaces' output via `surface.read_text` and asks one final agent to merge them:

```bash
VERDICT_SURFACE="${SURFS[3]}"
cmux send-surface --surface "$VERDICT_SURFACE" "claude 'Aggregate the three reviews above into one GO/NO-GO with top 3 blockers.'\n"
```

## Rules (from cmux-workspace skill — do not violate)

1. Always `--focus false`. Never `focus-pane` or `select-workspace`.
2. Scope to `CMUX_WORKSPACE_ID`. Do not touch other workspaces.
3. Build additively. No create-then-move chains.
4. Reuse an existing right-side helper pane if one exists; only create one if needed.
