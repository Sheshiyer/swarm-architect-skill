---
name: "Swarm Architect"
description: "Design execution-ready multi-agent delivery plans with phase→wave→swarm decomposition, contract-first parallelism, and GitHub synchronization."
globs:
  - "DesignSpec.md"
  - "ProjectArchitecture.md"
  - ".context/**/*.md"
  - "docs/architecture/**/*.md"
requiredSources:
  - github
---

# Swarm Architect

Use this skill to design and orchestrate **multi-agent execution-ready delivery plans** from specs, architecture docs, and repository context.

This skill is not a lightweight checklist generator. It is the orchestration layer for:
- discovery,
- plan shaping,
- phase → wave → swarm decomposition,
- contract-first parallelization,
- GitHub issue synchronization,
- and collision-resistant multi-agent delivery.

## When to Use

Activate this skill when the work involves any of the following:
- architecture or implementation planning with 3+ meaningful steps,
- multiple independent execution tracks,
- multiple coding agents working in the same repository,
- GitHub issue creation/update from a delivery plan,
- phase/wave-based rollout or hardening,
- or a need for explicit validation and dependency management.

If the task is trivial, use a lighter planning flow instead.

## Mandatory Companion Files

When this skill is invoked, load these files before producing the plan.

### Operating rules
1. `playbooks/multi-agent-boundaries.md`
2. `playbooks/worktree-strategy.md`
3. `playbooks/verification-gates.md`
4. `playbooks/github-sync.md`
5. `playbooks/claude-codex-copilot-gemini-operating-model.md` when the active stack matches that workflow
6. `playbooks/openviking-memory-ops.md` when memory-aware swarm execution is requested

### Output scaffolds
5. `templates/discovery-template.md`
6. `templates/phase-wave-swarm-template.md`
7. `templates/github-issue-template.md`
8. `templates/agent-handoff-template.md`
9. `templates/openviking-memory-capture-template.md` when memory records need to be written explicitly

### Structured defaults
10. `schemas/task-schema.json`
11. `schemas/issue-mapping-schema.json`
12. `schemas/agent-role-matrix.yaml`

### Usage references
13. `examples/sample-plan.md` when the user asks for a sample full plan
14. `examples/sample-wave.md` when the user asks for a detailed wave example
15. `examples/sample-agent-assignment.md` when the user asks how agents should be split
16. `docs/openviking-memory-mapping.md` when memory-aware swarm execution or retrieval design is in scope

## Adjacent Skills to Leverage

When available in the active runtime, use these as companion protocols:
- `using-superpowers` → skill discovery and ordering discipline
- `dispatching-parallel-agents` → independent parallel swarm execution
- `coding-agent` → launching supported coding agents safely when implementation is delegated
- `gemini` → test design, regression analysis, and adversarial validation

## Workflow

### 1. Discovery is mandatory
Run a short discovery pass unless the user already supplied the answers.
Capture at minimum:
- planning depth: `lean | standard | deeply detailed`
- delivery mode: `prototype | production | hardening`
- CI/CD expectations: `none | basic | production-grade`
- release model: `single milestone | phased rollout`
- quality bar: testing, observability, performance, security
- team topology: `solo | small squad | multi-squad`
- coding agents available and intended role split
- external constraints: deadline, compliance, platform, data, or regulatory constraints

Use `templates/discovery-template.md` as the canonical prompt/output frame.

### 2. Load planning context
Prioritize these inputs when present:
- `DesignSpec.md`
- `ProjectArchitecture.md`
- `.context/architecture/overview.md`
- `.context/architecture/patterns.md`
- `.context/auth/overview.md`
- `.context/testing.md`
- `.context/workflows.md`
- `.context/errors.md`
- `.context/api/headers.md`
- `.context/feature-flags.md`
- `.context/performance.md`
- `.context/monitoring.md`
- `.context/ui/patterns.md`

If the user asks to process all context docs, enumerate relevant `.context/**` files instead of silently omitting them.

### 3. Build the plan with strict structure
Default target: **80 tasks**.
Minimum granularity: **70 tasks** unless the user explicitly wants smaller scope.

Required hierarchy:
- top-level **Phases**,
- **Phase 1** split into at least **3 Waves** by default,
- each Wave containing at least **2 Swarms**,
- each Swarm focused on one primary concern.

Use the schema in `schemas/task-schema.json` for every task.

### 4. Enforce contract-first parallelism
Before assigning parallel build work:
- freeze API contracts,
- freeze shared schema/type expectations,
- freeze config/env expectations,
- freeze UI integration boundaries,
- and define validation evidence up front.

Do not send multiple agents into overlapping implementation zones without an explicit integration contract.

### 5. Apply multi-agent safety rules
The default operating model is:
- **one issue → one owner → one branch/worktree**,
- shared-file lock zones are serialized,
- contract changes force re-planning or an integration swarm,
- and merges happen at **wave boundaries**, not continuously.

Use `playbooks/multi-agent-boundaries.md` and `playbooks/worktree-strategy.md` to define safe ownership.

### 6. Synchronize with GitHub
When the user wants execution tracking:
- map tasks to GitHub issues,
- preserve dependencies in issue text/checklists/comments,
- align phase/wave/swarm IDs with issue metadata,
- and post concise wave summaries as work advances.

Use `playbooks/github-sync.md` and `templates/github-issue-template.md` as the canonical mapping rules.

### 7. Verify before declaring done
Every wave must include dedicated validation tasks.
Never mark work complete without evidence such as:
- tests,
- logs,
- status checks,
- screenshots,
- metrics,
- or diff validation.

Use `playbooks/verification-gates.md` for the completion standard.

## Output Contract

A Swarm Architect response should present, in order:
1. Discovery summary
2. Assumptions and constraints
3. Agent ownership model
4. Phase map
5. Detailed Phase 1 Wave/Swarm layout
6. Full task list using the defined schema
7. Dependency rationale
8. Verification strategy
9. GitHub sync and dispatch strategy
10. Risks and fallback plan

## Default Agent Model

Unless the user overrides it, use this baseline split:
- **Planner / orchestrator agent** → orchestration, planning, issue graph, review
- **UI / app implementation agent** → architecture implementation, UI, app integration
- **Cloud / backend agent** → cloud, infra, deployment, backend integration
- **Validation agent** → tests, regressions, adversarial validation

Example mapping when available:
- Claude can fill the planner / orchestrator role
- Codex can fill the UI / app implementation role
- Copilot can fill the cloud / backend role
- Gemini can fill the validation role

Refine ownership using `schemas/agent-role-matrix.yaml`.

## Definition of Done

A Swarm Architect plan is done only when:
- discovery is complete,
- required context has been loaded,
- structure includes phases, waves, and swarms,
- tasks are schema-complete and dependency-aware,
- agent ownership and collision boundaries are explicit,
- verification strategy is explicit,
- and GitHub synchronization is defined when requested.
