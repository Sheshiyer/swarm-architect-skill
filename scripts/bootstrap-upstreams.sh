#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
REPO_ROOT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --repo-root)
      REPO_ROOT="$2"
      shift 2
      ;;
    -h|--help)
      cat <<'EOF'
Usage: scripts/bootstrap-upstreams.sh [--dry-run] [--repo-root <path>]

Clone upstream specialist/methodology repos once into .external/ and emit
.swarm-upstream-resources.json so OpenViking bootstrap can reference them.
Uses .swarm-bootstrap.json when present, otherwise .swarm-bootstrap.example.json.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$REPO_ROOT" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

CONFIG_FILE="$REPO_ROOT/.swarm-bootstrap.json"
if [[ ! -f "$CONFIG_FILE" ]]; then
  CONFIG_FILE="$REPO_ROOT/.swarm-bootstrap.example.json"
fi

json_get() {
  python3 - "$CONFIG_FILE" "$1" "$2" <<'PY'
import json, os, sys
config_path, dotted_key, default = sys.argv[1:4]
if not os.path.exists(config_path):
    print(default)
    raise SystemExit(0)
with open(config_path, 'r', encoding='utf-8') as fh:
    data = json.load(fh)
value = data
for part in dotted_key.split('.'):
    if isinstance(value, dict) and part in value:
        value = value[part]
    else:
        print(default)
        raise SystemExit(0)
if isinstance(value, bool):
    print('true' if value else 'false')
elif value is None:
    print(default)
else:
    print(value)
PY
}

expand_path() {
  python3 - "$1" "$REPO_ROOT" <<'PY'
import os, sys
path, repo_root = sys.argv[1:3]
path = os.path.expanduser(path)
if not os.path.isabs(path):
    path = os.path.join(repo_root, path)
print(os.path.normpath(path))
PY
}

clone_once() {
  local name="$1"
  local enabled="$2"
  local repo_url="$3"
  local target_path="$4"
  local branch="$5"

  if [[ "$enabled" != "true" ]]; then
    echo "- $name: disabled"
    return 0
  fi

  if [[ -d "$target_path/.git" ]]; then
    echo "- $name: already present at $target_path"
    return 0
  fi

  echo "- $name: cloning $repo_url -> $target_path"
  if [[ "$DRY_RUN" == "true" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$target_path")"
  git clone --depth 1 --branch "$branch" "$repo_url" "$target_path"
}

AGENCY_ENABLED="$(json_get 'upstreams.agencyAgents.enabled' 'true')"
AGENCY_REPO="$(json_get 'upstreams.agencyAgents.repo' 'https://github.com/msitarzewski/agency-agents.git')"
AGENCY_PATH_RAW="$(json_get 'upstreams.agencyAgents.path' '.external/agency-agents')"
AGENCY_BRANCH="$(json_get 'upstreams.agencyAgents.branch' 'main')"
AGENCY_PATH="$(expand_path "$AGENCY_PATH_RAW")"

IMPECCABLE_ENABLED="$(json_get 'upstreams.impeccable.enabled' 'true')"
IMPECCABLE_REPO="$(json_get 'upstreams.impeccable.repo' 'https://github.com/pbakaus/impeccable.git')"
IMPECCABLE_PATH_RAW="$(json_get 'upstreams.impeccable.path' '.external/impeccable')"
IMPECCABLE_BRANCH="$(json_get 'upstreams.impeccable.branch' 'main')"
IMPECCABLE_PATH="$(expand_path "$IMPECCABLE_PATH_RAW")"

REGISTRY_PATH="$REPO_ROOT/.swarm-upstream-resources.json"

echo "Swarm bootstrap upstreams"
echo "- repo root: $REPO_ROOT"
echo "- config: $CONFIG_FILE"
echo "- dry run: $DRY_RUN"

clone_once "agency-agents" "$AGENCY_ENABLED" "$AGENCY_REPO" "$AGENCY_PATH" "$AGENCY_BRANCH"
clone_once "impeccable" "$IMPECCABLE_ENABLED" "$IMPECCABLE_REPO" "$IMPECCABLE_PATH" "$IMPECCABLE_BRANCH"

python3 - "$REGISTRY_PATH" "$REPO_ROOT" "$DRY_RUN" \
  "$AGENCY_ENABLED" "$AGENCY_REPO" "$AGENCY_PATH_RAW" "$AGENCY_PATH" \
  "$IMPECCABLE_ENABLED" "$IMPECCABLE_REPO" "$IMPECCABLE_PATH_RAW" "$IMPECCABLE_PATH" <<'PY'
import json, os, sys
(
    registry_path,
    repo_root,
    dry_run,
    agency_enabled,
    agency_repo,
    agency_path_raw,
    agency_path,
    impeccable_enabled,
    impeccable_repo,
    impeccable_path_raw,
    impeccable_path,
) = sys.argv[1:12]

def make_entry(name, enabled, repo, local_path_raw, local_path_abs):
    present = os.path.isdir(os.path.join(local_path_abs, '.git'))
    return {
        'name': name,
        'enabled': enabled == 'true',
        'present': present,
        'repo': repo,
        'localPath': local_path_raw,
        'absolutePath': local_path_abs,
        'resourceUri': f'viking://resources/upstreams/{name}',
        'profilesRoot': f'viking://resources/upstreams/{name}',
    }

registry = {
    'repoRoot': repo_root,
    'upstreams': {
        'agency-agents': make_entry('agency-agents', agency_enabled, agency_repo, agency_path_raw, agency_path),
        'impeccable': make_entry('impeccable', impeccable_enabled, impeccable_repo, impeccable_path_raw, impeccable_path),
    },
}
print(json.dumps(registry, indent=2))
if dry_run != 'true':
    with open(registry_path, 'w', encoding='utf-8') as fh:
        json.dump(registry, fh, indent=2)
        fh.write('\n')
PY

echo "- upstream registry: $REGISTRY_PATH"
echo "Done."
