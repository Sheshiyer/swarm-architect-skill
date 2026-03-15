#!/usr/bin/env bash
set -euo pipefail

ROOT_PATH="${SUPERSET_ROOT_PATH:-}"
WORKSPACE_NAME="${SUPERSET_WORKSPACE_NAME:-}"
WORKSPACE_DIR="$(pwd)"
LOCAL_SWARM_DIR="$WORKSPACE_DIR/.swarm"
LOCAL_TMP_DIR="$LOCAL_SWARM_DIR/tmp"

mkdir -p "$LOCAL_SWARM_DIR" "$LOCAL_TMP_DIR"

copy_if_exists() {
  local src="$1"
  local dest="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    return 0
  fi
  return 1
}

resolve_worker_packet() {
  local root="$1"
  local workspace="$2"
  local candidates=(
    "$root/.swarm/workers/$workspace.md"
    "$root/.swarm/workers/$workspace/session-bootstrap.md"
    "$root/.swarm/workers/$workspace/bootstrap.md"
  )
  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -f "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

install_deps() {
  if [[ -f package.json ]]; then
    if [[ -f bun.lockb || -f bun.lock ]]; then
      if command -v bun >/dev/null 2>&1; then
        echo "- installing Node dependencies with bun"
        bun install
        return 0
      fi
    fi
    if [[ -f pnpm-lock.yaml ]]; then
      if command -v pnpm >/dev/null 2>&1; then
        echo "- installing Node dependencies with pnpm"
        pnpm install --frozen-lockfile || pnpm install
        return 0
      fi
    fi
    if [[ -f yarn.lock ]]; then
      if command -v yarn >/dev/null 2>&1; then
        echo "- installing Node dependencies with yarn"
        yarn install --frozen-lockfile || yarn install
        return 0
      fi
    fi
    if command -v npm >/dev/null 2>&1; then
      echo "- installing Node dependencies with npm"
      if [[ -f package-lock.json ]]; then
        npm ci || npm install
      else
        npm install
      fi
      return 0
    fi
  fi

  if [[ -f pyproject.toml || -f requirements.txt ]]; then
    if command -v uv >/dev/null 2>&1; then
      echo "- syncing Python dependencies with uv"
      uv sync || true
      return 0
    fi
    if command -v pip >/dev/null 2>&1 && [[ -f requirements.txt ]]; then
      echo "- installing Python requirements with pip"
      pip install -r requirements.txt || true
      return 0
    fi
  fi

  echo "- no recognized dependency install step detected"
}

echo "Swarm Architect Superset setup"
echo "- workspace dir: $WORKSPACE_DIR"
echo "- root path: ${ROOT_PATH:-not provided}"
echo "- workspace name: ${WORKSPACE_NAME:-not provided}"

if [[ -n "$ROOT_PATH" && -d "$ROOT_PATH/.swarm" ]]; then
  echo "- found root .swarm bootstrap directory"

  copy_if_exists "$ROOT_PATH/.swarm/shared/project-brief.md" "$LOCAL_SWARM_DIR/project-brief.md" || true
  copy_if_exists "$ROOT_PATH/.swarm/shared/contracts.md" "$LOCAL_SWARM_DIR/shared-contracts.md" || true
  copy_if_exists "$ROOT_PATH/.swarm/shared/validation-gate.md" "$LOCAL_SWARM_DIR/validation-gate.md" || true
  copy_if_exists "$ROOT_PATH/.swarm/shared/launch-manifest.json" "$LOCAL_SWARM_DIR/launch-manifest.json" || \
    copy_if_exists "$ROOT_PATH/.swarm/launch-manifest.json" "$LOCAL_SWARM_DIR/launch-manifest.json" || true

  if [[ -n "$WORKSPACE_NAME" ]]; then
    if WORKER_PACKET="$(resolve_worker_packet "$ROOT_PATH" "$WORKSPACE_NAME")"; then
      copy_if_exists "$WORKER_PACKET" "$LOCAL_SWARM_DIR/session-bootstrap.md" || true
      echo "- worker packet linked from: $WORKER_PACKET"
    else
      echo "- warning: no worker packet found for workspace '$WORKSPACE_NAME'"
    fi
  fi

  if [[ ! -f .env && -f "$ROOT_PATH/.env" ]]; then
    cp "$ROOT_PATH/.env" .env
    echo "- copied root .env to workspace .env"
  fi
else
  echo "- warning: root .swarm bootstrap directory not found; setup will continue without packet materialization"
fi

install_deps

cat <<'EOF'

Workspace ready.
Read first, when present:
- .swarm/session-bootstrap.md
- .swarm/shared-contracts.md
- .swarm/validation-gate.md
- .swarm/launch-manifest.json

If you need project-specific or personal extra steps, extend via .superset/config.local.json.
EOF
