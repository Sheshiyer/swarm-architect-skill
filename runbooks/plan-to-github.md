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
7. **For tasks with `copilot_eligible: true`**: after creating the issue, hand off to `runbooks/route-to-copilot-agent.md` for preflight + `agent-ready` label application. Do NOT set the assignee from this session — the target repo's workflow does that with its own PAT. See `playbooks/copilot-coding-agent.md` for rules.

## Outputs
- GitHub issue mapping strategy
- issue-ready task summaries
- owner / branch / worktree boundaries
- dependency notes for issue bodies
- Dispatch Readiness line when any task is `copilot_eligible`: `Dispatch: X human · Y copilot · Z blocked`

## Verification checklist
- one issue has one clear owner (human handle OR `copilot-swe-agent[bot]`, never both on one issue)
- dependency order is visible
- lock-zone/shared-file tasks are serialized
- issue text includes acceptance or validation evidence expectations
- issues routed to the autonomous Copilot lane have passed `runbooks/route-to-copilot-agent.md` preflight
- no issue carries both `agent:copilot` (IDE-assist human role) and `agent-ready` (autonomous bot dispatch)

## Common failure modes
- turning the whole plan into one giant issue
- assigning the same implementation zone to multiple owners
- failing to encode dependencies in issue text
- omitting validation evidence expectations
- labeling `agent-ready` on a repo that is not Copilot-bootstrapped (dispatch workflow will fail)
- trying to assign `copilot-swe-agent[bot]` from this session (the default `GITHUB_TOKEN` cannot; only the target repo's `COPILOT_ASSIGN_PAT` can)
