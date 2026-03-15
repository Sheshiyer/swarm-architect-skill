# Runbook: Superset Workspace Bootstrap

## When to use
Use this runbook when a team uses **Superset workspaces/worktrees** and wants Swarm Architect handoff artifacts to be materialized automatically during workspace creation.

## Division of responsibility
### Swarm Architect
- generates shared contract packets
- generates worker bootstrap packets
- generates launch manifest data
- decides workspace naming conventions

### Superset
- creates the workspace
- runs setup commands in the workspace directory
- exposes `SUPERSET_ROOT_PATH` and `SUPERSET_WORKSPACE_NAME`
- runs teardown on workspace deletion

## Recommended naming pattern
Use deterministic workspace names so setup can find the correct packet:
- `codex-<wave>-<task>`
- `copilot-<wave>-<task>`
- `gemini-<wave>-<validation>`

## Expected root artifacts
The setup script expects Swarm Architect to have generated root-level artifacts under `.swarm/`, such as:
- `.swarm/shared/project-brief.md`
- `.swarm/shared/contracts.md`
- `.swarm/shared/validation-gate.md`
- `.swarm/shared/launch-manifest.json`
- `.swarm/workers/<workspace-name>.md`

## Setup flow
1. Superset creates a workspace.
2. `./.superset/setup.sh` runs in the workspace.
3. The script uses `SUPERSET_ROOT_PATH` to find root `.swarm/` artifacts.
4. The script copies or materializes local convenience files under workspace `.swarm/`.
5. The worker runtime starts by reading `.swarm/session-bootstrap.md` and `.swarm/shared-contracts.md`.

## Teardown flow
1. Superset deletes the workspace.
2. `./.superset/teardown.sh` runs.
3. Only workspace-local cleanup should happen by default.
4. Project-specific destructive cleanup should be added through local overrides, not the committed team script.

## Verification checklist
- workspace names match the generated worker packet names
- root `.swarm/` artifacts exist before workspace creation
- setup script is conservative and idempotent
- teardown avoids destructive root-level cleanup
- personal project steps are added through `config.local.json` or user overrides

## Common failure modes
- no root `.swarm/` artifacts generated before workspace creation
- non-deterministic workspace names that do not map to packet names
- putting expensive orchestration logic into setup scripts
- using teardown to clean root state instead of workspace-local state only
