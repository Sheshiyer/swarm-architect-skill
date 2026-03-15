# Discovery Template

Use this template before generating the plan unless the user already supplied the answers.

## 1. Planning Profile
- **Planning depth:** `lean | standard | deeply detailed`
- **Delivery mode:** `prototype | production | hardening`
- **Release model:** `single milestone | phased rollout`
- **CI/CD expectation:** `none | basic | production-grade`

## 2. Quality Bar
- **Testing depth:**
- **Observability requirements:**
- **Performance constraints:**
- **Security/compliance requirements:**
- **Rollback expectations:**

## 3. Team and Agent Topology
- **Human team shape:** `solo | small squad | multi-squad`
- **Available coding agents:**
- **Primary planner/orchestrator agent:**
- **Default ownership split:**
  - Planner / orchestrator agent:
  - UI / app implementation agent:
  - Cloud / backend agent:
  - Validation agent:
  - Other agents:

## 4. Repository / Delivery Constraints
- **Repo or workspace scope:**
- **Target base branch:**
- **Monorepo or single app:**
- **Sensitive/shared files to protect:**
- **Environment or secrets constraints:**
- **Deadline / milestone dates:**

## 5. Integration Risk Areas
- **Contract surfaces likely to change:**
- **Subsystems with shared ownership risk:**
- **External dependencies / vendors:**
- **Migration or backward-compatibility concerns:**

## 6. Planning Defaults to Confirm
If not specified, assume:
- 80 tasks target
- Phase 1 has at least 3 waves
- Each wave has at least 2 swarms
- One issue → one owner → one branch/worktree
- Shared-file lock zones are serialized
- Each wave includes explicit validation work

## 7. Discovery Summary Output
Return a compact summary:
- confirmed inputs
- assumptions made
- unresolved questions
- proposed agent split
- recommended plan depth and rollout shape
