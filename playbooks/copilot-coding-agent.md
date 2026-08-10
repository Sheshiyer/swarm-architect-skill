# GitHub Copilot Coding Agent — Autonomous Worker Playbook

Use this playbook when the plan should route eligible tasks directly to GitHub's **Copilot coding agent** (`copilot-swe-agent[bot]`) — GitHub's autonomous cloud worker that picks up issues, writes code in an ephemeral VM, and opens draft PRs without a human driver.

## 1. Disambiguation — two different "Copilot"s

Swarm Architect already ships an operating model that lists **Copilot** as a role in the four-agent stack (see `playbooks/claude-codex-copilot-gemini-operating-model.md`). That older usage means "a human engineer driving GitHub Copilot IDE assist on the backend/cloud surface." It is a **human + IDE assistant** pattern — the human still owns the branch and merges.

This playbook is about a different actor:

| Concept | Who is driving? | Output | Trigger |
|---|---|---|---|
| **Copilot (IDE assistant)** — the older role in `claude-codex-copilot-gemini-operating-model.md` | Human engineer | Commits authored by the human | Human types and accepts suggestions |
| **Copilot coding agent** — this playbook | Autonomous cloud VM | Draft PR authored by `copilot-swe-agent[bot]` | Assignment to the bot, typically via `agent-ready` label |

Both can coexist on the same repo. Both can even work on the same plan. But they have different ownership rules, different guardrails, and different dispatch mechanics. Do not mix them in the same task. A task is either `copilot_eligible: true` (autonomous agent) **or** owned by a human (optionally using Copilot IDE assist) — never both.

## 2. When to route to the autonomous agent

A task is a candidate for the Copilot coding agent when **all** of these are true:

- The task is well-scoped: a concrete deliverable, testable acceptance criteria, and an explicit list of files of interest.
- The scope fits in **one branch / one PR**. The agent cannot fan out across branches.
- The work does not require reading secrets, writing production credentials, or touching destructive infra steps.
- The target repo is **Copilot-bootstrapped** (see §5 below).
- A second reviewer is available — GitHub blocks the issue creator from being the final PR approver.
- The task is not under an `agent-blocked` label (explicit opt-out).

Set `copilot_eligible: true` in the task schema only when all of the above hold. Otherwise keep the task in the human lane.

## 3. When NOT to route

Stay in the human lane for:

- Architectural decisions, contract-freeze work, or any task that requires coordinating across multiple PRs.
- Anything that touches lock-zone files (`package.json`, root CI config, shared generated types, app-shell routers — see `playbooks/claude-codex-copilot-gemini-operating-model.md` §4).
- Tasks whose acceptance criteria are not yet concrete enough to be testable.
- Security-sensitive work (auth primitives, cryptography, credential rotation, RBAC policy).
- Anything tagged `agent-blocked`.

When in doubt, keep it human. An over-scoped agent PR is more expensive than a small human change.

## 4. Trigger mechanism

The agent is invoked by **assigning the exact bot login** `copilot-swe-agent[bot]` to the issue. Two important quirks:

- The literal strings `copilot` and `copilot-swe-agent` both return HTTP 422. Only `copilot-swe-agent[bot]` works.
- The default `GITHUB_TOKEN` **cannot** assign the bot (also 422). The target repo must hold a Personal Access Token as the `COPILOT_ASSIGN_PAT` secret, and a workflow there does the assignment via GraphQL.

**Swarm Architect itself never calls the assignment API.** It applies the `agent-ready` label; the target repo's workflow does the rest. This keeps PATs out of the planner's process and ensures label application is auditable and reversible.

The end-to-end flow:

```
Swarm Architect plan
    │
    ▼  task.copilot_eligible == true
Issue created using templates/github-issue-template.md
    │
    ▼  apply `agent-ready` label
Target repo: .github/workflows/copilot-agent-dispatch.yml fires
    │
    ▼  uses COPILOT_ASSIGN_PAT + two GraphQL calls
`copilot-swe-agent[bot]` assigned to the issue
    │
    ▼  within minutes
Draft PR opens, authored by the bot, linking to the issue
    │
    ▼  reviewer comments `@copilot <instruction>` as needed
Second reviewer approves and merges
```

## 5. Target-repo bootstrap requirements

Before any dispatch can succeed, the target repo must ship these files on its default branch:

| File | Purpose |
|---|---|
| `.github/copilot-instructions.md` | Repo-wide agent guidance (stack, build/test commands, conventions). |
| `.github/instructions/<role>.instructions.md` | Optional path-scoped rails. `tests.instructions.md` (forbid new `.skip`/`.only`) is recommended. |
| `.github/workflows/copilot-setup-steps.yml` | Preinstalls deps into the agent's VM. Job MUST be named `copilot-setup-steps`. Ubuntu or Windows only. |
| `.github/workflows/copilot-agent-dispatch.yml` | Label-to-assign workflow that fires on `issues: [labeled]` for `agent-ready`. |
| `.github/actions/assign-copilot/action.yml` | Composite action wrapping the two GraphQL calls. Single source of truth for the bot login. |
| `.github/ISSUE_TEMPLATE/agent-ready-task.md` | Enforces the issue body contract (Goal / Context / Acceptance criteria / Files of interest / Out of scope). |

Canonical copies ship in this skill at [`templates/copilot-agent-bootstrap/`](../templates/copilot-agent-bootstrap/). When the planner identifies a new target repo that has `copilot_eligible` tasks, it should either (a) hand the bootstrap files to a human to apply, or (b) propose an issue that does the copy.

## 6. Preflight — Business / Enterprise org

For org-owned repos, Copilot coding agent is **disabled by default**. Dispatch will fail until:

1. **Enterprise admin** enables third-party coding agents at the enterprise Agents page.
2. **Org owner** enables Copilot coding agent under Settings → Copilot → Policies.
3. The **target repo** is opted in under the same settings page.
4. The repo has the `COPILOT_ASSIGN_PAT` secret set (fine-grained PAT; RW on Actions, Contents, Issues, Pull requests; scoped to the target repo only).
5. A **second reviewer** is identified up front.

If any check fails, Swarm Architect falls back to the human lane for the affected tasks and surfaces the failing check in the plan's "Risks and fallback plan" section.

## 7. Iterating on draft PRs

Once Copilot opens a draft PR:

- The agent reacts with 👀 and posts progress via Actions runs.
- Review feedback is delivered by commenting `@copilot <instruction>` on the PR — this resumes the agent on the same branch.
- GitHub enforces that the issue creator is not the final approver. Route to a second reviewer.
- Do not auto-approve agent PRs. Always require a human eyes-on step.

## 8. Collision rules with existing operating model

When the four-agent stack (Claude + Codex + Copilot-IDE + Gemini) is active **and** the autonomous coding agent is also in play, apply these tie-breakers:

- If a task's owner agent is `copilot` (the IDE-assist human role) **and** `copilot_eligible: true`, treat it as owned by the **autonomous agent**. Record the handoff explicitly. Two Copilots on the same task is an anti-pattern.
- Autonomous-agent PRs still obey the wave model: no merges mid-wave without a waived integration gate.
- Lock-zone rules apply unchanged. The autonomous agent is not allowed to touch lock-zone files unless Claude explicitly created an integration task for it.
- Validation remains Gemini's job (or the human QA role). A green draft PR from the autonomous agent is not a substitute for adversarial validation.

## 9. Known quirks (verified against GitHub docs, April 2026)

- `gh issue edit --add-assignee "copilot-swe-agent[bot]"` is flaky for the bot login. The dispatch workflow uses `gh api graphql` instead.
- `actions/checkout` `fetch-depth` is silently overridden inside the agent VM.
- Setup-step failures do not abort the agent — it starts with a partial environment and produces confusing diffs. The dispatch workflow should fail loudly instead.
- The agent works on exactly one branch and opens exactly one PR per task. It cannot fan out.
- `copilot-setup-steps.yml` has a hard cap of 59 minutes and supports only Ubuntu x64 or Windows 64-bit. macOS is not supported.
- Custom MCP servers must be whitelisted in repo Settings → Copilot → Coding agent; `.vscode/mcp.json` alone is not honored by the cloud agent.

## 10. Pinned constants

| Constant | Value |
|---|---|
| Bot login | `copilot-swe-agent[bot]` |
| Opt-in label | `agent-ready` |
| Opt-out label | `agent-blocked` |
| PAT secret name | `COPILOT_ASSIGN_PAT` |
| Setup-workflow job name | `copilot-setup-steps` |
| Required issue body sections | `### Goal`, `### Context`, `### Acceptance criteria`, `### Files of interest`, `### Out of scope` |

Changes to any of these strings must land in this playbook and in `templates/copilot-agent-bootstrap/` simultaneously — they are the contract.
