# GitHub Synchronization Playbook

Use this playbook when the plan needs to be represented in GitHub issues, comments, and PRs.

## Core Mapping
- **Plan** → milestone / epic / parent issue set
- **Phase** → milestone section, epic label, or parent issue grouping
- **Wave** → issue batch and reporting checkpoint
- **Swarm** → label or parent grouping by execution track
- **Task** → individual issue

## Required Issue Metadata
Every task issue should include:
- task ID,
- phase / wave / swarm,
- area,
- owner role,
- owner agent,
- dependencies,
- deliverable,
- acceptance,
- validation,
- branch / worktree,
- lock-zone notes if relevant.

Use `templates/github-issue-template.md` as the default body.

## Labels
Recommended label families:
- `phase:p1`, `phase:p2`, ...
- `wave:w1`, `wave:w2`, ...
- `swarm:ui`, `swarm:infra`, `swarm:qa`, ...
- `area:frontend`, `area:backend`, `area:infra`, ...
- `agent:craft`, `agent:codex`, `agent:copilot`, `agent:gemini`
- `status:planned`, `status:ready`, `status:blocked`, `status:in-progress`, `status:in-review`, `status:done`

## State Transitions
Suggested state flow:
1. `planned`
2. `ready`
3. `in-progress`
4. `in-review`
5. `done`

Use `blocked` when a dependency, contract, or integration issue prevents progress.

## Dependency Representation
If GitHub dependency tooling is unavailable, represent dependencies in the issue body and in a pinned wave summary comment.

At minimum, store:
- upstream task IDs,
- upstream issue URLs,
- whether the dependency is hard or soft,
- what evidence unlocks the task.

## Wave Summaries
At the start of each wave, post a summary comment or issue update containing:
- wave goal,
- included task IDs,
- owner split,
- contract baseline,
- blocking dependencies,
- validation targets.

At wave close, post:
- completed tasks,
- deferred tasks,
- validation evidence,
- contract changes,
- integration risks for next wave.

## PR Linkage
Every PR should reference:
- the owning task issue,
- the phase / wave / swarm,
- upstream dependencies if relevant,
- and evidence for acceptance.

## Dispatch Compatibility
When dispatching task batches to separate agents:
- confirm repo and base branch,
- dispatch only independent tasks in the same batch,
- avoid dispatching multiple tasks that compete for lock-zone files,
- require each agent to post completion notes back to its issue or PR.
