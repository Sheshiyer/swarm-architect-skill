# Runbook: Memory Capture

## When to use
Use this runbook when Swarm Architect output should produce durable OpenViking-compatible memory records or deterministic retrieval paths.

## Required inputs
- memory-aware execution is requested
- target scope (`plan`, `phase`, `wave`, `swarm`, `task`, `validation`)
- relevant summaries, evidence, and outputs

## Steps
1. Load `playbooks/openviking-memory-ops.md`.
2. Load `docs/openviking-memory-mapping.md`.
3. Load `templates/openviking-memory-capture-template.md`.
4. Identify the target `memory_scope`, `memory_uri`, `memory_inputs`, and `memory_outputs`.
5. Record the correct summary for the scope:
   - discovery / plan summary
   - wave summary
   - swarm objective
   - task completion note
   - validation findings
6. If upstream resources are part of the execution model, note the relevant indexed `viking://resources/upstreams/...` URIs.

## Outputs
- memory capture record
- deterministic URI reference
- retrieval inputs for downstream work

## Verification checklist
- memory scope is explicit
- URI is deterministic
- inputs and outputs are named
- evidence is attached where applicable

## Common failure modes
- writing vague memory notes with no retrieval path
- mixing task and wave scope in the same record
- forgetting upstream resource references when they were used in execution
