# OpenViking Memory Operations Playbook

Use this playbook when Swarm Architect plans need durable, shared memory.

## Principle
Every major planning object should have a memory footprint:
- the project,
- the phase,
- the wave,
- the swarm,
- the task,
- and the validation result.

## Read / Write lifecycle

### Before planning
Retrieve:
- project baseline memory
- prior lessons
- prior wave summaries
- architecture and spec overviews

Write:
- discovery summary
- assumptions
- phase map

### Before starting a swarm
Retrieve:
- phase memory
- current wave memory
- upstream task memories
- relevant project resource summaries

Write:
- swarm objective
- scope and owned surfaces
- dependency state

### Before starting a task
Retrieve:
- task contract
- latest handoff
- upstream validation notes
- execution / quality / validation profiles

Write:
- task start note
- chosen branch/worktree
- decision log as needed

### After task completion
Write:
- completion summary
- validation evidence
- residual risks
- handoff packet

### At wave close
Write:
- wave summary
- deferred tasks
- integration findings
- reusable lessons

## Default role contracts

### Claude / planner-orchestrator
Reads:
- planning memory
- lessons
- dependency history

Writes:
- discovery records
- phase and wave summaries
- integration decisions
- escalations

### Codex / UI executor
Reads:
- UI swarm memory
- task memory
- quality profile
- contract summaries

Writes:
- implementation summary
- touched surfaces
- unresolved UI concerns
- handoff note

### Copilot / backend-cloud executor
Reads:
- backend/infra swarm memory
- task memory
- deployment constraints
- contract summaries

Writes:
- integration notes
- config impacts
- infrastructure risks
- handoff note

### Gemini / validator
Reads:
- task memory
- validation profile
- acceptance criteria
- defect history

Writes:
- regression report
- failure summaries
- release gate findings
- residual risk notes

## Retrieval discipline
- Prefer L0/L1 overviews before loading L2 detail.
- Retrieve by deterministic URI first, semantic search second.
- If retrieval paths become noisy, tighten directory structure before adding more memory.

## Memory-aware done standard
Work is not done until:
1. the deliverable exists,
2. validation is attached,
3. the relevant memory record is written,
4. and downstream retrieval paths are clear.
