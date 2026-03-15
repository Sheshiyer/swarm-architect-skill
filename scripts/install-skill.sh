#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
WORKSPACE_PATH=""
DEST_PATH=""
REPO_ROOT=""

usage() {
  cat <<'EOF'
Usage: scripts/install-skill.sh [options]

Install the Swarm Architect skill package into a Craft workspace.

Options:
  --workspace <path>   Craft workspace root (contains skills/)
  --dest <path>        Full destination path for the skill directory
  --repo-root <path>   Override repo root (default: script parent)
  --dry-run            Show what would be copied without writing
  -h, --help           Show this help

Examples:
  ./scripts/install-skill.sh --workspace ~/.craft-agent/workspaces/my-workspace
  ./scripts/install-skill.sh --dest ~/.craft-agent/workspaces/my-workspace/skills/swarm-architect
  ./scripts/install-skill.sh --workspace ~/.craft-agent/workspaces/my-workspace --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      WORKSPACE_PATH="$2"
      shift 2
      ;;
    --dest)
      DEST_PATH="$2"
      shift 2
      ;;
    --repo-root)
      REPO_ROOT="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$REPO_ROOT" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

expand_path() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.expanduser(sys.argv[1]))
PY
}

if [[ -n "$WORKSPACE_PATH" ]]; then
  WORKSPACE_PATH="$(expand_path "$WORKSPACE_PATH")"
fi
if [[ -n "$DEST_PATH" ]]; then
  DEST_PATH="$(expand_path "$DEST_PATH")"
fi

if [[ -z "$DEST_PATH" ]]; then
  if [[ -z "$WORKSPACE_PATH" ]]; then
    echo "Either --workspace or --dest is required." >&2
    usage >&2
    exit 1
  fi
  DEST_PATH="$WORKSPACE_PATH/skills/swarm-architect"
fi

FILES=(
  "SKILL.md"
  "icon.svg"
  ".gitignore"
  ".swarm-bootstrap.example.json"
  "docs"
  "examples"
  "playbooks"
  "schemas"
  "scripts"
  "templates"
)

echo "Swarm Architect installer"
echo "- repo root: $REPO_ROOT"
echo "- destination: $DEST_PATH"
echo "- dry run: $DRY_RUN"

echo "- items to copy:"
for item in "${FILES[@]}"; do
  echo "  - $item"
done

if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run complete."
  exit 0
fi

mkdir -p "$DEST_PATH"
for item in "${FILES[@]}"; do
  src="$REPO_ROOT/$item"
  if [[ -e "$src" ]]; then
    rm -rf "$DEST_PATH/$item"
    cp -R "$src" "$DEST_PATH/$item"
  else
    echo "Warning: missing source item $item" >&2
  fi
done

cat <<EOF
Install complete.

Next steps:
1. Invoke the skill from your Craft workspace as \
   [skill:swarm-architect]
2. Optional bootstrap:
   cp "$DEST_PATH/.swarm-bootstrap.example.json" "$DEST_PATH/.swarm-bootstrap.json"
   "$DEST_PATH/scripts/bootstrap-upstreams.sh"
   "$DEST_PATH/scripts/bootstrap-openviking.sh"
EOF
