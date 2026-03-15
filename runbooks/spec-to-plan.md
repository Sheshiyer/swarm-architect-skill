# Runbook: Spec to Plan

## When to use
Use this runbook when a user has a feature idea, architecture brief, spec, or repository context and needs a structured Swarm Architect delivery plan.

## Required inputs
- a design spec, feature brief, or architecture request
- delivery mode (`prototype`, `production`, or `hardening`)
- known runtime agents if available
- notable constraints (deadline, compliance, performance, rollout)

## Steps
1. Run discovery using `templates/discovery-template.md`.
2. Load core planning context from `DesignSpec.md`, `ProjectArchitecture.md`, and relevant `.context/**` files.
3. Select the right operating playbooks:
   - `playbooks/multi-agent-boundaries.md`
   - `playbooks/worktree-strategy.md`
   - `playbooks/verification-gates.md`
   - `playbooks/github-sync.md` when execution tracking is needed
4. Define the agent ownership model using:
   - `schemas/agent-role-matrix.yaml`
   - `schemas/runtime-role-catalog.yaml`
5. Build the phase → wave → swarm structure with `templates/phase-wave-swarm-template.md`.
6. Expand the task list using `schemas/task-schema.json`.
7. Attach verification and GitHub sync strategy before declaring the plan complete.

## Outputs
- discovery summary
- assumptions and constraints
- agent ownership model
- phase map
- detailed phase 1 wave/swarms
- dependency-aware task list
- verification strategy
- GitHub sync strategy when requested

## Verification checklist
- discovery captured
- context sources named
- contracts frozen before parallel work
- owners explicit
- validation tasks included
- GitHub mapping present if requested

## Common failure modes
- skipping discovery and guessing constraints
- parallelizing overlapping file zones too early
- missing validation tasks
- leaving issue sync implicit instead of explicit
