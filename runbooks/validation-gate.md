# Runbook: Validation Gate

## When to use
Use this runbook when a plan, swarm, or wave needs explicit validation criteria before work can be considered complete.

## Required inputs
- acceptance expectations
- delivery mode
- testing / observability / performance / security requirements
- risk level

## Steps
1. Load `playbooks/verification-gates.md`.
2. Determine the gate level:
   - prototype
   - production
   - hardening
3. Name the required evidence types:
   - tests
   - logs
   - status checks
   - screenshots
   - metrics
   - security findings
4. Attach the validation tasks directly to the relevant wave or swarm.
5. Assign a validation owner or validation profile when needed.

## Outputs
- explicit validation requirements
- evidence checklist
- pass/fail conditions

## Verification checklist
- the gate matches delivery mode
- evidence types are explicit
- the gate is attached to the plan structure, not left generic
- an owner exists for validation execution or review

## Common failure modes
- saying “verify later” without adding tasks
- treating tests as the only evidence source
- under-scoping validation for production or hardening work
