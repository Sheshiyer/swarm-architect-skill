#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
WAIT=false
TIMEOUT=""
REPO_ROOT=""
CLI_CMD=""
REPLACE_EXISTING=false
ONLY=""
IGNORE_DIRS=".git,node_modules,dist,build,target,.venv,venv,__pycache__"

usage() {
  cat <<'EOF'
Usage: scripts/index-openviking-resources.sh [options]

Index Swarm Architect upstream resources into OpenViking using the generated
.swarm-upstream-resources.json registry.

Options:
  --dry-run                 Print the commands without executing them
  --wait                    Wait for semantic processing after indexing
  --timeout <seconds>       Timeout passed to `openviking wait`
  --repo-root <path>        Override repo root (default: script parent)
  --cli <command>           Override CLI binary (default: openviking, fallback: ov)
  --only <names>            Comma-separated upstream names to index
  --replace-existing        Remove an existing target URI before re-importing it
  --ignore-dirs <csv>       Directories to ignore during add-resource
  -h, --help                Show this help

Recommended flow:
  cp .swarm-bootstrap.example.json .swarm-bootstrap.json
  ./scripts/bootstrap-upstreams.sh
  ./scripts/bootstrap-openviking.sh
  ./scripts/index-openviking-resources.sh --dry-run
  ./scripts/index-openviking-resources.sh --wait
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --wait)
      WAIT=true
      shift
      ;;
    --timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --repo-root)
      REPO_ROOT="$2"
      shift 2
      ;;
    --cli)
      CLI_CMD="$2"
      shift 2
      ;;
    --only)
      ONLY="$2"
      shift 2
      ;;
    --replace-existing)
      REPLACE_EXISTING=true
      shift
      ;;
    --ignore-dirs)
      IGNORE_DIRS="$2"
      shift 2
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

REGISTRY_FILE="$REPO_ROOT/.swarm-upstream-resources.json"
PATHS_FILE="$REPO_ROOT/.swarm-openviking-paths.json"

resolve_cli() {
  if [[ -n "$CLI_CMD" ]]; then
    echo "$CLI_CMD"
    return 0
  fi
  if command -v openviking >/dev/null 2>&1; then
    echo "openviking"
    return 0
  fi
  if command -v ov >/dev/null 2>&1; then
    echo "ov"
    return 0
  fi
  echo ""
}

CLI_BIN="$(resolve_cli)"

if [[ ! -f "$REGISTRY_FILE" ]]; then
  echo "Missing $REGISTRY_FILE" >&2
  echo "Run ./scripts/bootstrap-upstreams.sh first." >&2
  exit 1
fi

if [[ "$DRY_RUN" != "true" && -z "$CLI_BIN" ]]; then
  echo "OpenViking CLI not found. Install/configure 'openviking' (or provide --cli <command>)." >&2
  echo "You can still inspect commands with --dry-run." >&2
  exit 1
fi

resource_exists() {
  local uri="$1"
  if [[ -z "$CLI_BIN" ]]; then
    return 1
  fi
  "$CLI_BIN" stat "$uri" >/dev/null 2>&1
}

print_cmd() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
}

echo "Swarm OpenViking indexing"
echo "- repo root: $REPO_ROOT"
echo "- registry: $REGISTRY_FILE"
echo "- paths file: ${PATHS_FILE}"
echo "- dry run: $DRY_RUN"
echo "- wait: $WAIT"
echo "- replace existing: $REPLACE_EXISTING"
echo "- selected upstreams: ${ONLY:-all enabled upstreams}"
echo "- ignore dirs: $IGNORE_DIRS"
echo "- cli: ${CLI_BIN:-not found (dry-run only)}"
if [[ -f "$PATHS_FILE" ]]; then
  python3 - "$PATHS_FILE" <<'PY'
import json, sys
with open(sys.argv[1], 'r', encoding='utf-8') as fh:
    data = json.load(fh)
print(f"- memory root: {data.get('memoryRoot', 'unknown')}")
PY
fi

INDEXED_COUNT=0
SKIPPED_COUNT=0

while IFS=$'\t' read -r name enabled present absolute_path resource_uri repo_url; do
  [[ -z "$name" ]] && continue

  if [[ "$enabled" != "true" ]]; then
    echo "- $name: skipped (disabled)"
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    continue
  fi

  if [[ "$present" != "true" || ! -e "$absolute_path" ]]; then
    echo "- $name: skipped (local path missing: $absolute_path)"
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    continue
  fi

  reason="Swarm Architect upstream resource import for $name from $repo_url"

  if [[ "$DRY_RUN" == "true" ]]; then
    if [[ "$REPLACE_EXISTING" == "true" ]]; then
      print_cmd "${CLI_BIN:-openviking}" rm "$resource_uri" --recursive
    fi
    CMD=("${CLI_BIN:-openviking}" add-resource "$absolute_path" --to "$resource_uri" --reason "$reason")
    if [[ -n "$IGNORE_DIRS" ]]; then
      CMD+=(--ignore-dirs "$IGNORE_DIRS")
    fi
    print_cmd "${CMD[@]}"
    INDEXED_COUNT=$((INDEXED_COUNT + 1))
    continue
  fi

  if resource_exists "$resource_uri"; then
    if [[ "$REPLACE_EXISTING" == "true" ]]; then
      echo "- $name: replacing existing resource $resource_uri"
      "$CLI_BIN" rm "$resource_uri" --recursive
    else
      echo "- $name: skipped (resource already exists at $resource_uri)"
      SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
      continue
    fi
  fi

  echo "- $name: indexing $absolute_path -> $resource_uri"
  CMD=("$CLI_BIN" add-resource "$absolute_path" --to "$resource_uri" --reason "$reason")
  if [[ -n "$IGNORE_DIRS" ]]; then
    CMD+=(--ignore-dirs "$IGNORE_DIRS")
  fi
  "${CMD[@]}"
  INDEXED_COUNT=$((INDEXED_COUNT + 1))
done < <(
  python3 - "$REGISTRY_FILE" "$ONLY" <<'PY'
import json, sys
registry_file, only = sys.argv[1:3]
with open(registry_file, 'r', encoding='utf-8') as fh:
    data = json.load(fh)
selected = {item.strip() for item in only.split(',') if item.strip()}
for name, meta in sorted(data.get('upstreams', {}).items()):
    if selected and name not in selected:
        continue
    row = [
        name,
        'true' if meta.get('enabled') else 'false',
        'true' if meta.get('present') else 'false',
        str(meta.get('absolutePath', '')),
        str(meta.get('resourceUri', f'viking://resources/upstreams/{name}')),
        str(meta.get('repo', '')),
    ]
    print('\t'.join(part.replace('\t', ' ') for part in row))
PY
)

if [[ "$WAIT" == "true" ]]; then
  if [[ "$DRY_RUN" == "true" ]]; then
    if [[ -n "$TIMEOUT" ]]; then
      print_cmd "${CLI_BIN:-openviking}" wait --timeout "$TIMEOUT"
    else
      print_cmd "${CLI_BIN:-openviking}" wait
    fi
  elif [[ "$INDEXED_COUNT" -gt 0 ]]; then
    echo "- waiting for OpenViking processing"
    if [[ -n "$TIMEOUT" ]]; then
      "$CLI_BIN" wait --timeout "$TIMEOUT"
    else
      "$CLI_BIN" wait
    fi
  fi
fi

echo "Summary: indexed=$INDEXED_COUNT skipped=$SKIPPED_COUNT"
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run complete."
fi
