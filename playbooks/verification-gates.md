# Verification Gates Playbook

This playbook defines how work is proven complete.

## Principle
No task, swarm, or wave is complete without evidence.

## Task-Level Evidence
Every task must define at least one of:
- automated test proof,
- manual validation steps,
- log or metric evidence,
- screenshot or preview evidence,
- schema / contract validation,
- CI status checks.

## Wave-Level Gates
Every wave should include dedicated validation tasks.

### Wave completion checklist
- [ ] upstream dependencies were satisfied
- [ ] acceptance criteria were met for included tasks
- [ ] required validation evidence exists
- [ ] no unresolved contract drift remains
- [ ] lock-zone changes were reviewed intentionally
- [ ] downstream handoffs are documented

## Contract Validation
Before launching or closing a parallel wave, confirm:
- API signatures still match the contract,
- shared types/schema are aligned,
- config/env expectations are unchanged or explicitly versioned,
- UI integration assumptions are still valid.

## Integration Gates
For integration waves, require:
- merged dependency set is coherent,
- CI baseline is green,
- smoke tests pass,
- no hidden branch-local changes remain,
- rollback path is defined for production work.

## Regression Gates
When Gemini or another validation agent is used, expect:
- regression suite definition,
- edge-case coverage,
- adversarial test notes,
- summary of residual risk.

## Done Standard
Mark work done only when:
1. the deliverable exists,
2. acceptance is satisfied,
3. validation evidence is attached,
4. downstream risk is communicated,
5. GitHub issue / PR state is updated.
