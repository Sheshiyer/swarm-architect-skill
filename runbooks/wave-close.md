# Runbook: Wave Close

## When to use
Use this runbook when a wave is nearing completion and the orchestrator needs to decide whether it is safe to integrate, close, and move forward.

## Required inputs
- completed wave task list
- validation evidence from each swarm
- integration findings
- unresolved risks or deferred tasks

## Steps
1. Gather evidence from each swarm owner.
2. Load `playbooks/verification-gates.md`.
3. Confirm lock-zone changes have been merged safely.
4. Review any remaining dependency or regression risks.
5. Produce a concise wave summary:
   - completed work
   - deferred work
   - validation evidence
   - residual risks
   - next-wave readiness
6. If memory-aware execution is in use, load `templates/openviking-memory-capture-template.md` and record the closeout.

## Outputs
- wave summary
- integration findings
- deferred tasks list
- next-wave recommendation

## Verification checklist
- each swarm supplied evidence
- integration tests/checks are represented
- deferred work is named, not implied
- next wave can begin without hidden blockers

## Common failure modes
- closing a wave because coding finished while verification is still incomplete
- losing unresolved risks in chat history instead of recording them
- skipping integration checks between swarms
