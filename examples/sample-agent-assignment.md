# Sample Agent Assignment

## Project Split

### Claude
- Orchestrates discovery, planning depth, phase/wave/swarm structure
- Creates or updates GitHub issues and dependency mapping
- Reviews wave boundaries and integration gates
- Owns integration decisions and wave-close approval

### Codex
- Owns UI feature implementation
- Owns app integration tasks
- Works only in task-specific branches/worktrees

### Copilot
- Owns cloud/backend/infrastructure work
- Owns deployment and environment wiring
- Avoids broad edits to app UI surfaces

### Gemini
- Owns test planning, regression analysis, adversarial validation
- Can open defects or validation tasks
- Should not silently rewrite unrelated production code as a primary owner
- Escalates contract-breaking findings back to Claude for re-planning or integration decisions

## Shared Rules
- one issue → one owner → one branch/worktree
- no direct co-editing on the same branch
- lock-zone files require serialized ownership
- merge at wave boundaries
- contract changes trigger re-planning or a dedicated integration task

## Example Branch Set
- `swarm/payments/p2-w2/ui/T-042-codex`
- `swarm/payments/p2-w2/infra/T-051-copilot`
- `swarm/payments/p2-w2/qa/T-067-gemini`

## Example Worktree Set
- `.worktrees/T-042-codex`
- `.worktrees/T-051-copilot`
- `.worktrees/T-067-gemini`
