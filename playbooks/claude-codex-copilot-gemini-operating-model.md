# Claude + Codex + Copilot + Gemini Operating Model

Use this playbook when the active multi-agent stack is:
- **Claude** for planning and orchestration
- **Codex** for UI and app implementation
- **Copilot** for backend, cloud, and integration plumbing
- **Gemini** for test design, regression analysis, and adversarial validation

This playbook turns the generic Swarm Architect rules into a concrete day-to-day operating model.

## 1. Role Map

### Claude
Owns:
- discovery and plan shaping
- phase / wave / swarm decomposition
- GitHub issue graph and dependency map
- contract freeze decisions
- integration reviews
- wave-close decisions

Avoids:
- broad overlapping implementation across the same surfaces owned by Codex or Copilot
- ad hoc direct edits in multiple worker branches unless acting as an explicit integration task owner

### Codex
Owns:
- UI feature implementation
- app integration
- frontend architecture realization
- client-side workflows and local feature polish

Avoids:
- deployment plumbing
- cloud infrastructure ownership
- broad edits to backend or infra surfaces unless the task explicitly assigns that scope

### Copilot
Owns:
- backend integration
- cloud services and infrastructure
- CI/CD and deployment wiring
- environment/config plumbing
- server-side contracts after freeze implementation

Avoids:
- broad UI ownership
- app-shell UX decisions unless a task explicitly requires cross-surface integration

### Gemini
Owns:
- test planning
- regression design
- adversarial and edge-case validation
- branch-level verification notes
- defect discovery and validation follow-ups

Avoids:
- becoming the default primary implementation owner for unrelated product code
- silently changing core contracts without reopening the relevant planning task

## 2. Ownership Rules
- **One issue → one owner → one branch/worktree**
- Claude owns planning and orchestration issues by default
- Codex owns UI/app execution issues by default
- Copilot owns backend/cloud/integration issues by default
- Gemini owns QA/validation/regression issues by default
- No two agents co-edit the same branch
- Shared-file lock zones require serialized ownership or a dedicated integration task
- Contract changes force re-planning, a contract update task, or an integration swarm

## 3. Suggested File-Surface Boundaries

These are defaults, not absolutes. Override only when the issue explicitly says so.

### Codex default surfaces
- `apps/web/**`
- `src/components/**`
- `src/features/**`
- client-side state and routing below the app surface
- local UI tests that validate the owned feature area

### Copilot default surfaces
- `services/api/**`
- `infra/**`
- deployment configuration
- CI wiring
- server-side jobs, integrations, and environment plumbing

### Gemini default surfaces
- `tests/**`
- regression reports
- validation notes
- test fixtures
- defect summaries

### Claude default surfaces
- planning docs
- orchestration notes
- issue dependency maps
- integration summaries
- contract review notes

## 4. Lock-Zone Files

These require serialized ownership or an explicit integration issue:
- `package.json`
- lockfiles
- root CI config
- repo-wide lint/formatter config
- top-level router or app shell files
- shared generated types
- environment contract files

Default rule: if Codex and Copilot both need the same lock-zone file, Claude must create an integration issue instead of allowing uncontrolled overlap.

## 5. Wave Operating Model

### Wave 1 — Contract Freeze
Claude leads this wave.

Outputs:
- frozen API contracts
- shared schema/type expectations
- environment/config expectations
- UI integration boundaries
- validation definitions

Exit rule:
No parallel implementation begins until Claude marks the contract baseline ready.

### Wave 2 — Parallel Build
Codex and Copilot work in parallel on disjoint task batches.
Gemini prepares or begins validation work in parallel where possible.

Rules:
- no shared branch edits
- no silent contract drift
- no lock-zone collisions without explicit ownership

### Wave 3 — Integration
Claude owns the integration wave unless a separate integration owner is assigned.

Inputs:
- Codex handoff notes
- Copilot handoff notes
- Gemini validation findings

Outputs:
- merged integration state
- resolved cross-surface conflicts
- updated issue/PR linkage

### Wave 4 — Hardening and Validation
Gemini leads deep validation, Claude decides closure, Codex/Copilot fix issues by ownership area.

Outputs:
- regression status
- unresolved risk list
- release readiness signal

## 6. Handoff Protocol

Every agent handoff should include:
1. issue ID and PR/branch link
2. short summary of what changed
3. validation evidence
4. lock-zone files touched, if any
5. contract changes or confirmation of no contract drift
6. blockers or next dependency unlocked

### Minimum handoff expectations by agent
- **Codex**: UI behavior summary, screenshots or local validation notes, downstream API assumptions
- **Copilot**: service/infrastructure summary, config impacts, deployment/CI notes
- **Gemini**: failing/passing evidence, edge cases checked, residual risk summary
- **Claude**: integration decision, dependency updates, next-wave recommendation

## 7. Escalation Rules
Escalate back to Claude when:
- Codex and Copilot need the same lock-zone file
- a frozen API or schema contract must change
- Gemini finds failures that invalidate acceptance criteria
- CI breaks due to cross-agent integration
- two issues turn out not to be independent

When escalation happens:
1. stop the conflicting work
2. reopen or create the contract/integration task
3. update issue dependencies
4. relaunch only after the new boundary is clear

## 8. Daily Operating Rhythm
1. **Claude** runs discovery and creates the wave plan
2. **Claude** creates or updates GitHub issues with dependencies and ownership
3. **Codex** pulls the UI/app batch for the wave
4. **Copilot** pulls the backend/cloud batch for the wave
5. **Gemini** prepares regression cases and validates delivered branches
6. **Claude** closes the wave, resolves cross-surface conflicts, and approves the next wave launch

## 9. Practical Batch Pattern

### Good batch example
- Codex: `apps/web` checkout flow UI tasks
- Copilot: payment service and infra tasks
- Gemini: checkout regression pack
- Claude: dependency tracking and integration review

### Bad batch example
- Codex and Copilot both editing `package.json`, root CI, and shared generated types in parallel with no integration owner

If a batch looks like the bad example, split it differently before starting.

## 10. Definition of Healthy Operation
This stack is operating well when:
- Claude is coordinating through issues, contracts, and wave boundaries
- Codex and Copilot are working on disjoint file/task surfaces
- Gemini is validating instead of shadow-implementing
- integration happens intentionally, not accidentally
- and every merge has ownership and evidence behind it
