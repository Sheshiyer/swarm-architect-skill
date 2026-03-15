# Sample Plan

This is a compact example of how Swarm Architect should respond. Real plans should expand to 70–80+ tasks when scope demands it.

## 1. Discovery Summary
- Planning depth: deeply detailed
- Delivery mode: production
- Release model: phased rollout
- CI/CD expectation: production-grade
- Agents available: Claude, Codex, Copilot, Gemini
- Recommended ownership split: Claude coordinates, Codex owns UI/app, Copilot owns cloud/backend, and Gemini owns validation

## 2. Assumptions and Constraints
- Shared schema contracts can be frozen in Wave 1
- `package.json` and CI config are lock zones
- No direct cross-agent edits on the same branch

## 3. Agent Ownership Model
| Concern | Owner |
|---|---|
| Planning / issue graph | Claude |
| UI / app integration | Codex |
| Cloud / backend / infra | Copilot |
| Tests / regression | Gemini |

## 4. Phase Map
- **Phase 1:** contract freeze and execution scaffolding
- **Phase 2:** parallel implementation
- **Phase 3:** integration and hardening

## 5. Detailed Phase 1 Wave Layout
### Wave 1 — Contract freeze
- Swarm API: freeze backend routes and schema types
- Swarm UI: freeze app integration points and view contracts

### Wave 2 — Delivery scaffolding
- Swarm GitHub: create issue graph and dependency map
- Swarm CI: establish baseline checks and test jobs

### Wave 3 — Launch parallel work
- Swarm UI Build: start Codex-owned implementation branches
- Swarm Infra Build: start Copilot-owned backend/infra branches

## 6. Example Task Objects
```json
{
  "id": "T-001",
  "title": "Freeze checkout API contract",
  "area": "backend",
  "owner_role": "Platform Engineer",
  "owner_agent": "copilot",
  "phase": "P1",
  "wave": "W1",
  "swarm": "api-contracts",
  "est_hours": 6,
  "dependencies": [],
  "deliverable": "Approved API contract for checkout endpoints.",
  "acceptance": "Contract document and sample payloads are approved by orchestration and UI owners.",
  "validation": "Schema review completed and sample requests validate successfully.",
  "branch": "swarm/checkout/p1-w1/contracts/T-001-copilot",
  "worktree": ".worktrees/T-001-copilot",
  "lock_zone": false,
  "notes": "Unlocks UI and test swarms."
}
```

## 7. Dependency Rationale
Freeze contracts first, then parallelize build work, then integrate at wave boundaries.

## 8. Verification Strategy
Each wave ends with explicit validation tasks, CI checks, and handoff notes.

## 9. GitHub Sync Strategy
Each task becomes an issue with phase/wave/swarm labels and owner-agent metadata.

## 10. Risks and Fallback
If contract drift appears mid-wave, reopen the contract task and pause dependent swarms.
