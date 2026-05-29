#!/usr/bin/env bash
# cmux-hooks installer
# Detects which AI coding agents are on PATH and installs cmux notification hooks for them.
# Idempotent: existing files are backed up to <file>.bak.YYYYMMDD before being overwritten.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATESTAMP="$(date +%Y%m%d)"
DRY_RUN=0
UNINSTALL=0
ONLY=""

usage() {
  cat <<EOF
Usage: $0 [--only agent1,agent2,...] [--uninstall] [--dry-run]

Detects installed AI coding agents and wires up cmux notification hooks for them.

Supported agents:
  claude-code, codex, grok, cursor, gemini, hermes, copilot, opencode,
  factory, antigravity, amp, codebuddy, qoder, pi, rovo-dev

Options:
  --only LIST       Comma-separated list — install only these agents
  --uninstall       Remove installed hooks, restore .bak files
  --dry-run         Show what would happen without writing files
  -h, --help        This help
EOF
}

# ----- arg parse -----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --only) ONLY="$2"; shift 2 ;;
    --only=*) ONLY="${1#*=}"; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

# ----- sanity checks -----
if ! command -v cmux >/dev/null 2>&1; then
  echo "❌ cmux is not on PATH. Install it first:"
  echo "   brew tap manaflow-ai/cmux && brew install --cask cmux"
  echo "   sudo ln -sf '/Applications/cmux.app/Contents/Resources/bin/cmux' /usr/local/bin/cmux"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  jq is not installed. The hook scripts need it. Run: brew install jq"
fi

SOCK="${CMUX_SOCKET_PATH:-/tmp/cmux.sock}"
if [[ ! -S "$SOCK" ]]; then
  echo "⚠️  cmux socket not found at $SOCK — is cmux running? (Hooks will install but stay silent.)"
fi

# ----- agent table: name | detect-bin | install-dir | settings-file -----
AGENTS=(
  "claude-code|claude|$HOME/.claude/hooks|$HOME/.claude/settings.json"
  "codex|codex|$HOME/.codex/hooks|$HOME/.codex/config.json"
  "grok|grok|$HOME/.grok/hooks|$HOME/.grok/config.json"
  "cursor|cursor-agent|$HOME/.cursor/hooks|$HOME/.cursor/settings.json"
  "gemini|gemini|$HOME/.gemini/hooks|$HOME/.gemini/config.json"
  "hermes|hermes|$HOME/.hermes/hooks|$HOME/.hermes/config.yaml"
  "copilot|copilot|$HOME/.copilot/hooks|$HOME/.copilot/config.json"
  "opencode|opencode|$HOME/.opencode/hooks|$HOME/.opencode/config.json"
  "factory|droid|$HOME/.factory/hooks|$HOME/.factory/config.json"
  "antigravity|agy|$HOME/.antigravity/hooks|$HOME/.antigravity/config.json"
  "amp|amp|$HOME/.amp/hooks|$HOME/.amp/config.json"
  "codebuddy|codebuddy|$HOME/.codebuddy/hooks|$HOME/.codebuddy/config.json"
  "qoder|qodercli|$HOME/.qoder/hooks|$HOME/.qoder/config.json"
  "pi|pi|$HOME/.pi/hooks|$HOME/.pi/config.json"
  "rovo-dev|acli|$HOME/.rovo/hooks|$HOME/.rovo/config.json"
)

filter_only() {
  local name="$1"
  [[ -z "$ONLY" ]] && return 0
  IFS=',' read -ra wanted <<<"$ONLY"
  for w in "${wanted[@]}"; do
    [[ "$w" == "$name" ]] && return 0
  done
  return 1
}

backup() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  local bak="$f.bak.$DATESTAMP"
  [[ -f "$bak" ]] && return 0   # already backed up today
  if (( DRY_RUN )); then
    echo "    [dry-run] backup $f -> $bak"
  else
    cp "$f" "$bak"
    echo "    backup → $bak"
  fi
}

install_agent() {
  local name="$1" bin="$2" hooks_dir="$3" settings_file="$4"
  local src_dir="$REPO_DIR/$name"

  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "⏭️  $name — $bin not installed, skipping"
    return 0
  fi

  if [[ ! -d "$src_dir" ]]; then
    echo "⏭️  $name — no source files in repo, skipping"
    return 0
  fi

  echo "✅ $name — installing"

  if (( DRY_RUN )); then
    echo "    [dry-run] mkdir -p $hooks_dir"
    echo "    [dry-run] cp $src_dir/cmux-notify.sh -> $hooks_dir/"
  else
    mkdir -p "$hooks_dir"
    cp "$src_dir/cmux-notify.sh" "$hooks_dir/"
    chmod +x "$hooks_dir/cmux-notify.sh"
  fi

  if [[ -f "$src_dir/settings.snippet.json" ]]; then
    echo "    📋 settings snippet — merge into $settings_file"
    echo "       see: $src_dir/settings.snippet.json"
  fi
}

uninstall_agent() {
  local name="$1" bin="$2" hooks_dir="$3" settings_file="$4"

  if [[ ! -d "$hooks_dir" ]]; then
    echo "⏭️  $name — nothing to uninstall"
    return 0
  fi

  echo "🗑️  $name — removing hook"
  if (( DRY_RUN )); then
    echo "    [dry-run] rm $hooks_dir/cmux-notify.sh"
  else
    rm -f "$hooks_dir/cmux-notify.sh"
  fi
}

# ----- main -----
if (( UNINSTALL )); then
  echo "Uninstalling cmux hooks..."
  for row in "${AGENTS[@]}"; do
    IFS='|' read -r name bin hooks_dir settings_file <<<"$row"
    filter_only "$name" || continue
    uninstall_agent "$name" "$bin" "$hooks_dir" "$settings_file"
  done
  echo "Done."
  exit 0
fi

echo "Installing cmux hooks..."
echo ""

for row in "${AGENTS[@]}"; do
  IFS='|' read -r name bin hooks_dir settings_file <<<"$row"
  filter_only "$name" || continue
  install_agent "$name" "$bin" "$hooks_dir" "$settings_file"
done

echo ""
echo "Running 'cmux hooks setup' to register with cmux session-restore..."
if (( DRY_RUN )); then
  echo "[dry-run] cmux hooks setup"
else
  cmux hooks setup || echo "⚠️  'cmux hooks setup' returned non-zero — check cmux version (need v0.64.0+)"
fi

echo ""
echo "✨ Done. Test it:"
echo "   cmux notify --title 'Hooks installed' --body 'You should see this in the cmux sidebar'"
