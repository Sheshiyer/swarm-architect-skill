# Worktree Strategy Playbook

Use this playbook to isolate agent execution in a shared repository.

## Goals
- isolate changes physically,
- reduce branch collisions,
- keep task ownership explicit,
- and make integration predictable.

## Branch Naming
Recommended pattern:

`swarm/<initiative>/<phase>-<wave>/<swarm>/<task-id>-<agent>`

Examples:
- `swarm/payments/p1-w1/contracts/T-001-craft`
- `swarm/payments/p2-w4/ui/T-042-codex`
- `swarm/payments/p2-w4/infra/T-051-copilot`
- `swarm/payments/p3-w2/qa/T-067-gemini`

## Worktree Naming
Recommended pattern:

`.worktrees/<task-id>-<agent>`

Examples:
- `.worktrees/T-042-codex`
- `.worktrees/T-051-copilot`
- `.worktrees/T-067-gemini`

## Base Branch Rules
- Create all task branches from the current approved integration base.
- Prefer wave-specific refresh points instead of constant rebasing.
- Rebase only when the orchestrator declares a new wave baseline or when a blocking upstream task lands.

## Merge Cadence
Do **not** merge continuously from every branch into every other branch.
Instead:
1. freeze the baseline,
2. launch independent task branches,
3. merge accepted work into the integration branch at wave boundary,
4. refresh downstream branches only when needed.

## Shared-File Handling
When a task requires a lock-zone file:
- either route it to a dedicated integration task,
- or temporarily grant exclusive ownership to one task.

Document this in the issue and handoff notes.

## PR Expectations
Every PR should state:
- task ID,
- phase/wave/swarm,
- owner agent,
- upstream dependencies,
- validation evidence,
- lock-zone files touched.

## Cleanup
After merge or abandonment:
- remove stale worktrees,
- close or relabel stale issues,
- summarize unresolved integration concerns,
- keep only active worktrees tied to live issues.

## Default Safety Rule
If two agents need the same branch or worktree, the plan is wrong. Split the work differently or add an integration swarm.
