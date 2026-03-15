# Runbook: Plan to GitHub

## When to use
Use this runbook when a Swarm Architect plan needs to become GitHub issues, ownership boundaries, and execution tracking.

## Required inputs
- completed or near-complete Swarm Architect plan
- repository and issue-tracking intent
- phase / wave / swarm identifiers
- owner mapping

## Steps
1. Load `playbooks/github-sync.md`.
2. Load `templates/github-issue-template.md`.
3. Map each task or task bundle to the right GitHub granularity:
   - one issue per task for tightly tracked work
   - one issue per swarm for grouped execution
   - one issue per wave only when the work is intentionally coarse
4. Preserve dependencies in issue bodies/checklists/comments.
5. Keep one owner per issue and one branch/worktree per issue.
6. Add wave summaries and integration checkpoints for wave boundaries.

## Outputs
- GitHub issue mapping strategy
- issue-ready task summaries
- owner / branch / worktree boundaries
- dependency notes for issue bodies

## Verification checklist
- one issue has one clear owner
- dependency order is visible
- lock-zone/shared-file tasks are serialized
- issue text includes acceptance or validation evidence expectations

## Common failure modes
- turning the whole plan into one giant issue
- assigning the same implementation zone to multiple owners
- failing to encode dependencies in issue text
- omitting validation evidence expectations
