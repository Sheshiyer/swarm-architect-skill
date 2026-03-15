# Sample Wave

## Wave: P2-W2 — Parallel Feature Build

### Objective
Implement feature work in parallel without shared-state collisions.

### Swarms

#### Swarm A — UI and App Integration
- **Owner agent:** Codex
- **Allowed surface:** `apps/web/**`, feature-specific client state, local UI tests
- **Blocked from touching:** infra, deployment config, root CI files
- **Upstream dependency:** frozen API contract from `T-001`
- **Output:** working UI implementation with local validation evidence

#### Swarm B — Cloud / Backend Integration
- **Owner agent:** Copilot
- **Allowed surface:** `services/api/**`, `infra/**`, deployment plumbing
- **Blocked from touching:** app-shell UI, shared client components
- **Upstream dependency:** frozen API contract from `T-001`
- **Output:** backend/infrastructure support with deploy-safe configuration notes

#### Swarm C — Regression and Adversarial Validation
- **Owner agent:** Gemini
- **Allowed surface:** tests, validation reports, edge-case analysis
- **Blocked from touching:** production feature implementation unless explicitly assigned
- **Upstream dependency:** feature branches from Swarm A and B
- **Output:** regression report and bug findings for integration wave

### Wave Exit Criteria
- UI branch and backend branch each pass their scoped validation
- No lock-zone files were changed without explicit ownership
- Handoff notes are written for integration
- CI baseline is green enough to enter the integration wave
