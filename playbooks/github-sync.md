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
- **Autonomous-Copilot routing:** `agent-ready` (opt in, triggers dispatch) and `agent-blocked` (opt out, hard stop). See disambiguation below.

### `agent:copilot` vs `agent-ready` — important disambiguation
These two labels describe **different actors**:

- **`agent:copilot`** (member of the `agent:*` family) means "a human engineer driving GitHub Copilot IDE assist owns this issue." The human is the author. Ownership follows `playbooks/claude-codex-copilot-gemini-operating-model.md`.
- **`agent-ready`** (no colon, different family) means "route this issue to the autonomous GitHub Copilot coding agent, `copilot-swe-agent[bot]`." A workflow in the target repo picks this up and assigns the bot. The bot is the author. Ownership follows `playbooks/copilot-coding-agent.md`.

Never apply both to the same issue. If a task is routed to the autonomous agent, drop `agent:copilot` and rely on `agent-ready` alone.

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

## Autonomous Copilot Coding Agent

When any task in the plan has `copilot_eligible: true`, follow `runbooks/route-to-copilot-agent.md` to dispatch. Key rules from `playbooks/copilot-coding-agent.md`:

- **Never assign `copilot-swe-agent[bot]` directly from the planner.** The default `GITHUB_TOKEN` returns HTTP 422. Apply the `agent-ready` label only — the target repo's workflow handles assignment with its own PAT.
- **Target repo must be Copilot-bootstrapped.** The files under [`templates/copilot-agent-bootstrap/`](../templates/copilot-agent-bootstrap/) must be on the target repo's default branch before labeling.
- **Preflight the org policy.** Business/Enterprise orgs have Copilot coding agent disabled by default. Admin must enable it at the org level and opt in the target repo.
- **Second reviewer required.** GitHub blocks the issue creator from being the final PR approver for agent-authored PRs.
- **Never auto-approve** a Copilot draft PR.

Track dispatches in the wave summary with a Dispatch Readiness line: `Dispatch: X human · Y copilot · Z blocked`.
