# CLI Session Bootstrap Template

Use this template to start a **fresh worker CLI session** for Codex, Copilot, Gemini, or another execution agent after Swarm Architect finishes planning.

## Session Identity
- **Agent runtime:**
- **Role:**
- **Task ID:**
- **Phase / Wave / Swarm:**
- **GitHub issue / PR:**
- **Branch / worktree:**

## Objective
- Primary objective:
- Explicit non-goals:
- Why this session exists now:

## Read First
1. `handoff/shared/project-brief.md`
2. `handoff/shared/contracts.md`
3. `handoff/shared/validation-gate.md` when validation matters for execution
4. Agent-specific bootstrap file:
   - `handoff/<agent>/<task>-bootstrap.md`

## Ownership Envelope
- **Files / surfaces owned:**
- **Files intentionally untouched:**
- **Frozen contracts to respect:**
- **Lock-zone files to avoid unless escalated:**

## Execution Rules
- Stay inside the owned zone unless the orchestrator explicitly expands it.
- Do not silently change frozen contracts.
- If a shared contract must change, stop and escalate.
- Prefer producing evidence and a clean handback over broad opportunistic edits.

## Expected Deliverables
- Implementation or review summary:
- Files changed:
- Tests / checks run:
- Validation evidence:
- Residual risks:
- Handoff note path:

## Memory I/O
- **memory_scope:**
- **memory_uri:**
- **memory_inputs:**
- **memory_outputs:**

## Handback Format
Return to the orchestrator with:
1. summary of work completed,
2. files changed,
3. evidence produced,
4. unresolved blockers or risks,
5. recommended next owner or next step.
