# Runbook: Launch Worker Session

## When to use
Use this runbook when Swarm Architect has finished planning and needs to prepare a **fresh worker CLI session** for Codex, Copilot, Gemini, or another runtime.

## Required inputs
- completed or near-complete plan
- assigned task or validation scope
- shared contracts
- ownership boundaries
- GitHub issue / branch / worktree mapping
- memory-aware context if enabled

## Steps
1. Load `templates/shared-contract-packet-template.md` and prepare the shared packet for the current phase / wave / swarm.
2. Load `templates/cli-session-bootstrap-template.md` for implementation workers.
3. Load `templates/validation-brief-template.md` for validation workers.
4. Generate one agent-specific bootstrap packet per worker session.
5. Fill the launch manifest according to `machine-readable/session-bootstrap-schema.yaml`.
6. Ensure each packet includes:
   - role identity
   - objective and non-goals
   - owned surfaces
   - forbidden overlap zones
   - read-first files
   - expected deliverables
   - memory I/O
   - handback format
7. Start the worker session only after the packet is complete.

## Outputs
- shared contract packet
- one bootstrap packet per worker runtime
- launch manifest
- explicit handback expectations

## Verification checklist
- every worker has a unique owned zone
- frozen contracts are referenced explicitly
- the worker knows what not to edit
- evidence requirements are present
- memory URI and retrieval inputs are attached when in scope

## Common failure modes
- launching a worker with only a vague summary
- giving the worker the whole plan instead of the scoped packet
- omitting lock-zone restrictions
- failing to define the worker handback format
