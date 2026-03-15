# Phase → Wave → Swarm Template

Use this as the canonical plan scaffold.

## 1. Discovery Summary
- Planning depth:
- Delivery mode:
- Release model:
- Quality bar:
- Team/agent topology:
- Constraints:

## 2. Assumptions and Constraints
- Assumption A:
- Assumption B:
- Constraint A:
- Constraint B:

## 3. Agent Ownership Model
| Concern | Primary owner | Secondary reviewer | Notes |
|---|---|---|---|
| Planning / orchestration | Planner / orchestrator agent | Human lead | |
| UI / app integration | UI / app implementation agent | Planner / orchestrator agent | |
| Cloud / backend / infra | Cloud / backend agent | Planner / orchestrator agent | |
| Testing / adversarial validation | Validation agent | Planner / orchestrator agent | |

## 4. Phase Map
### Phase 1 — Contract and foundation setup
- Goal:
- Exit criteria:
- Waves:

### Phase 2 — Parallel implementation
- Goal:
- Exit criteria:
- Waves:

### Phase 3 — Integration and hardening
- Goal:
- Exit criteria:
- Waves:

## 5. Detailed Phase 1 Wave Layout
### Wave 1 — Contract freeze
#### Swarm A — API / schema contracts
- Goal:
- Owner:
- Inputs:
- Outputs:
- Validation:

#### Swarm B — UI / integration contracts
- Goal:
- Owner:
- Inputs:
- Outputs:
- Validation:

### Wave 2 — Delivery scaffolding
#### Swarm A — GitHub / issue structure
#### Swarm B — CI / test baseline

### Wave 3 — Parallel work launch
#### Swarm A — UI/app build prep
#### Swarm B — Cloud/backend build prep

## 6. Task List
For every task, use the schema from `schemas/task-schema.json`.

## 7. Dependency Rationale
Explain:
- what must happen before parallelization,
- what can be run independently,
- what requires an integration swarm,
- and what must remain serialized.

## 8. Verification Strategy
List:
- per-wave proof,
- contract validation,
- CI gates,
- regression expectations,
- rollout checks.

## 9. GitHub Sync Strategy
List:
- issue creation/update approach,
- labels/metadata,
- dependency representation,
- wave status comment protocol,
- PR linkage expectations.

## 10. Risks and Fallback Plan
- Risk:
- Trigger:
- Fallback:
