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
Usage: scripts/bootstrap-openviking.sh [--dry-run] [--repo-root <path>]

Prepare OpenViking bootstrap state for a repository:
- detects local tools
- resolves config path and mode
- writes a starter ov.conf if missing (unless --dry-run)
- generates .swarm-openviking-paths.json with deterministic URI patterns
- includes upstream resource roots when .swarm-upstream-resources.json is present
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

expand_user_path() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.expanduser(sys.argv[1]))
PY
}

MODE="$(json_get 'openviking.mode' 'local')"
CONFIG_PATH_RAW="$(json_get 'openviking.configPath' '~/.openviking/ov.conf')"
MEMORY_ROOT_TEMPLATE="$(json_get 'openviking.memoryRoot' 'viking://agent/memories/swarms/${repo}')"
PATHS_FILE_RAW="$(json_get 'openviking.pathsFile' '.swarm-openviking-paths.json')"

CONFIG_PATH="$(expand_user_path "$CONFIG_PATH_RAW")"
REMOTE_URL="$(git -C "$REPO_ROOT" config --get remote.origin.url 2>/dev/null || true)"
REPO_NAME="$(python3 - "$REMOTE_URL" "$REPO_ROOT" <<'PY'
import os, sys
remote_url, repo_root = sys.argv[1:3]
name = ""
if remote_url:
    tail = remote_url.rstrip('/').split('/')[-1]
    if tail.endswith('.git'):
        tail = tail[:-4]
    name = tail
if not name:
    name = os.path.basename(repo_root)
print(name)
PY
)"
MEMORY_ROOT="${MEMORY_ROOT_TEMPLATE//\$\{repo\}/$REPO_NAME}"
PATHS_FILE="$REPO_ROOT/$PATHS_FILE_RAW"
UPSTREAM_REGISTRY_FILE="$REPO_ROOT/.swarm-upstream-resources.json"

has_cmd() {
  command -v "$1" >/dev/null 2>&1 && echo yes || echo no
}

OPENVIKING_SERVER_PRESENT="$(has_cmd openviking-server)"
OV_CLI_PRESENT="$(has_cmd ov)"
PYTHON_PRESENT="$(has_cmd python3)"

echo "Swarm bootstrap OpenViking"
echo "- repo root: $REPO_ROOT"
echo "- repo name: $REPO_NAME"
echo "- config: $CONFIG_FILE"
echo "- mode: $MODE"
echo "- dry run: $DRY_RUN"
echo "- python3: $PYTHON_PRESENT"
echo "- openviking-server: $OPENVIKING_SERVER_PRESENT"
echo "- ov CLI: $OV_CLI_PRESENT"
echo "- OPENVIKING_CONFIG_FILE should point to: $CONFIG_PATH"
echo "- memory root: $MEMORY_ROOT"
if [[ -f "$UPSTREAM_REGISTRY_FILE" ]]; then
  echo "- upstream registry: $UPSTREAM_REGISTRY_FILE"
else
  echo "- upstream registry: not found (run bootstrap-upstreams.sh first for upstream visibility)"
fi

if [[ "$MODE" == "local" && ! -f "$CONFIG_PATH" ]]; then
  echo "- OpenViking config missing: $CONFIG_PATH"
  if [[ "$DRY_RUN" != "true" ]]; then
    mkdir -p "$(dirname "$CONFIG_PATH")"
    cat > "$CONFIG_PATH" <<'EOF'
{
  "storage": {
    "workspace": "~/openviking_workspace"
  },
  "log": {
    "level": "INFO",
    "output": "stdout"
  },
  "embedding": {
    "dense": {
      "api_base": "<api-endpoint>",
      "api_key": "<your-api-key>",
      "provider": "openai",
      "dimension": 3072,
      "model": "text-embedding-3-large"
    }
  },
  "vlm": {
    "api_base": "<api-endpoint>",
    "api_key": "<your-api-key>",
    "provider": "openai",
    "model": "gpt-4o"
  }
}
EOF
  fi
fi

python3 - "$PATHS_FILE" "$REPO_NAME" "$MEMORY_ROOT" "$DRY_RUN" "$UPSTREAM_REGISTRY_FILE" <<'PY'
import json, os, sys
paths_file, repo_name, memory_root, dry_run, upstream_registry_file = sys.argv[1:6]
registry = {
  'repo': repo_name,
  'memoryRoot': memory_root,
  'paths': {
    'planning': f'{memory_root}/planning',
    'phasePattern': f'{memory_root}/phases/{{phase}}',
    'wavePattern': f'{memory_root}/phases/{{phase}}/{{wave}}',
    'swarmPattern': f'{memory_root}/phases/{{phase}}/{{wave}}/{{swarm}}',
    'taskPattern': f'{memory_root}/tasks/{{taskId}}',
    'validationPattern': f'{memory_root}/validations/{{validationId}}',
    'handoffRoot': f'{memory_root}/handoffs',
    'lessonsRoot': f'{memory_root}/lessons',
  },
}
if os.path.exists(upstream_registry_file):
    with open(upstream_registry_file, 'r', encoding='utf-8') as fh:
        upstream_registry = json.load(fh)
    upstreams = upstream_registry.get('upstreams', {})
    registry['upstreams'] = {}
    for name, meta in upstreams.items():
        registry['upstreams'][name] = {
            'enabled': meta.get('enabled', False),
            'present': meta.get('present', False),
            'localPath': meta.get('localPath'),
            'absolutePath': meta.get('absolutePath'),
            'resourceUri': meta.get('resourceUri', f'viking://resources/upstreams/{name}'),
            'profilesRoot': meta.get('profilesRoot', f'viking://resources/upstreams/{name}'),
        }
print(json.dumps(registry, indent=2))
if dry_run != 'true':
    with open(paths_file, 'w', encoding='utf-8') as fh:
        json.dump(registry, fh, indent=2)
        fh.write('\n')
PY

echo "- next step: optionally index upstream repos into OpenViking resources, e.g. viking://resources/upstreams/..."
echo "Done."
