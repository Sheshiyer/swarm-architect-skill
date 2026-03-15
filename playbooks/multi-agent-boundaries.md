# Multi-Agent Boundaries Playbook

This playbook defines how multiple coding agents can work in the same repository safely.

## Core Principle
Agents should **not continuously sync with each other**. They should coordinate through:
- task ownership,
- frozen contracts,
- isolated branches/worktrees,
- explicit handoffs,
- and wave-boundary integration.

## Mandatory Rules

### 1. One issue → one owner → one branch/worktree
Every implementation task must have:
- a unique task ID,
- a single primary owner,
- one branch,
- one worktree,
- and one explicit allowed edit surface.

### 2. Freeze contracts before parallel build
Before launching parallel swarms, freeze at least:
- API contracts,
- shared types/schema,
- environment/config contract,
- UI integration boundaries,
- validation expectations.

If a contract changes later, stop and create a contract update task or integration swarm. Do not silently drift.

### 3. No overlapping ownership inside a wave
Inside the same wave, two agents should not co-own the same implementation surface unless the work item is explicitly an integration task.

Good split:
- UI / app implementation agent → UI, app integration, architecture implementation
- Cloud / backend agent → cloud, infra, backend integration
- Validation agent → test authoring, adversarial validation, regression analysis
- Planner / orchestrator agent → orchestration, issue graph, review, integration control

### 4. Shared-file lock zones are serialized
Treat these as lock zones unless a dedicated integration swarm owns them:
- `package.json`
- lockfiles
- root CI config
- repo-wide lint / formatter config
- top-level routing or app shell files
- shared generated types / schema artifacts
- environment/config definitions

Only one active owner at a time may change a lock-zone file.

### 5. Handoffs are contract-driven
Downstream work should depend on:
- issue state,
- PR links,
- acceptance criteria,
- validation evidence,
- and explicit handoff notes.

Do not rely on informal chat memory as the system of record.

## Escalation Rules
Escalate and re-plan when:
- a frozen contract must change,
- two swarms need the same lock-zone file,
- a task crosses multiple ownership domains,
- validation evidence contradicts acceptance,
- or wave goals were wrong or incomplete.

## Anti-Patterns
Avoid these patterns:
- multiple agents editing the same branch,
- multiple agents rebasing continuously against each other,
- ad hoc edits to shared config without issue ownership,
- handoffs with no evidence,
- silent contract changes.

## Recommended Default Ownership Matrix
| Concern | Primary agent | Notes |
|---|---|---|
| Plan / architecture / sequencing | Planner / orchestrator agent | Orchestrates issue graph and wave boundaries |
| UI / app integration | UI / app implementation agent | Owns feature UX and client integration |
| Cloud / backend / infra | Cloud / backend agent | Owns infra, backend integration, deployment plumbing |
| Test design / regressions | Validation agent | Owns test cases, adversarial checks, validation analysis |
| Integration gate review | Planner / orchestrator agent | Verifies cross-swarm coherence |

## Definition of Safe Parallelism
Parallel work is safe only when all of these are true:
- contracts are explicit,
- ownership is disjoint,
- lock zones are serialized,
- downstream dependencies are known,
- and integration happens through planned wave boundaries.
