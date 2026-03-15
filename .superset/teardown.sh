#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_NAME="${SUPERSET_WORKSPACE_NAME:-unknown-workspace}"
WORKSPACE_DIR="$(pwd)"

echo "Swarm Architect Superset teardown"
echo "- workspace: $WORKSPACE_NAME"
echo "- dir: $WORKSPACE_DIR"

if [[ -d .swarm/tmp ]]; then
  rm -rf .swarm/tmp
  echo "- removed .swarm/tmp"
fi

echo "- no root-level cleanup performed"
echo "- extend via .superset/config.local.json if your project needs extra teardown steps"
