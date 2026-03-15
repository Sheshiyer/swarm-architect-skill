---
name: "Swarm Architect"
description: "Orchestrate multi-agent delivery with phase→wave→swarm planning, worker bootstrap packets for fresh CLI sessions, GitHub synchronization, and OpenViking-ready memory capture."
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
10. `templates/shared-contract-packet-template.md` when fresh worker CLI sessions must share frozen contracts
11. `templates/cli-session-bootstrap-template.md` when launching a fresh Codex, Copilot, Gemini, or similar worker session
12. `templates/validation-brief-template.md` when launching a dedicated validation session

### Structured defaults
10. `schemas/task-schema.json`
11. `schemas/issue-mapping-schema.json`
12. `schemas/agent-role-matrix.yaml`
13. `schemas/runtime-role-catalog.yaml` when runtime responsibilities or owner role clarity are needed

### Lightweight runbooks
14. `runbooks/spec-to-plan.md` when starting from a feature brief, spec, or architecture request
15. `runbooks/plan-to-github.md` when the plan must become GitHub-tracked execution work
16. `runbooks/wave-close.md` when a wave needs integration closeout and next-wave readiness review
17. `runbooks/validation-gate.md` when validation requirements need to be explicit before execution
18. `runbooks/memory-capture.md` when OpenViking-compatible memory records must be shaped
19. `runbooks/launch-worker-session.md` when a fresh worker CLI session must be launched from a scoped handoff packet
20. `runbooks/superset-workspace-bootstrap.md` when Superset setup/teardown automation should provision worker workspaces from generated packets

### Usage references
21. `examples/sample-plan.md` when the user asks for a sample full plan
22. `examples/sample-wave.md` when the user asks for a detailed wave example
23. `examples/sample-agent-assignment.md` when the user asks how agents should be split
24. `docs/openviking-memory-mapping.md` when memory-aware swarm execution or retrieval design is in scope
25. `docs/bootstrap.md` when first-run environment setup, upstream cloning, or OpenViking preparation is requested
26. `machine-readable/reference.yaml` when a compact package map is needed
27. `machine-readable/workflows.yaml` when workflow selection is ambiguous
28. `machine-readable/profiles.yaml` when role/profile overlays need a compact summary
29. `machine-readable/session-bootstrap-schema.yaml` when generating launch manifests or worker startup packets

## Adjacent Skills to Leverage

When available in the active runtime, use these as companion protocols:
- `using-superpowers` → skill discovery and ordering discipline
- `dispatching-parallel-agents` → independent parallel swarm execution
- `coding-agent` → launching supported coding agents safely when implementation is delegated
- `gemini` → test design, regression analysis, and adversarial validation

## Workflow

Before planning, choose the closest operating path:
- use `runbooks/spec-to-plan.md` for normal planning from specs or architecture briefs
- use `runbooks/plan-to-github.md` when GitHub execution tracking is a first-class output
- use `runbooks/validation-gate.md` when the quality bar or release gate must be made explicit early
- use `runbooks/wave-close.md` when assessing integration readiness at a wave boundary
- use `runbooks/memory-capture.md` when OpenViking-compatible records or retrieval paths must be shaped
- use `runbooks/launch-worker-session.md` when a fresh Codex, Copilot, Gemini, or similar CLI session must be started from a scoped handoff packet
- use `runbooks/superset-workspace-bootstrap.md` when Superset should provision and clean up the worker workspace automatically

If workflow selection is ambiguous, consult `machine-readable/workflows.yaml` before proceeding.

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
10. Worker bootstrap packet strategy when fresh external CLI workers will be launched
11. Risks and fallback plan

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

Refine ownership using `schemas/agent-role-matrix.yaml` and `schemas/runtime-role-catalog.yaml`.

## Definition of Done

A Swarm Architect plan is done only when:
- discovery is complete,
- required context has been loaded,
- structure includes phases, waves, and swarms,
- tasks are schema-complete and dependency-aware,
- agent ownership and collision boundaries are explicit,
- verification strategy is explicit,
- and GitHub synchronization is defined when requested.
