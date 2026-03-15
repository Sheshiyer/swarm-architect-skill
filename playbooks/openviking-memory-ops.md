# OpenViking Memory Operations Playbook

Use this playbook when Swarm Architect plans need durable, shared memory.

## Principle
Every major planning object should have a memory footprint:
- the project,
- the phase,
- the wave,
- the swarm,
- the task,
- the validation result,
- and any indexed upstream reference material the swarm depends on.

## Bootstrap and ingestion workflow
Before relying on upstream context in planning or execution, prepare and ingest it explicitly:

```bash
cp .swarm-bootstrap.example.json .swarm-bootstrap.json
./scripts/bootstrap-upstreams.sh
./scripts/bootstrap-openviking.sh
./scripts/index-openviking-resources.sh --dry-run
./scripts/index-openviking-resources.sh --wait
```

After indexing, the default upstream resource roots are:
- `viking://resources/upstreams/agency-agents`
- `viking://resources/upstreams/impeccable`

Use these URIs as deterministic retrieval anchors before falling back to broader semantic search.

## Read / Write lifecycle

### Before planning
Retrieve:
- project baseline memory
- prior lessons
- prior wave summaries
- architecture and spec overviews
- indexed upstream resources that shape worker or quality profiles

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
- indexed upstream profile roots

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
- indexed profile or methodology documents referenced by those profiles

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
- indexed upstream strategy/profile references

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
- indexed frontend quality references

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
- indexed implementation references

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
- indexed validation/checklist references

Writes:
- regression report
- failure summaries
- release gate findings
- residual risk notes

## Retrieval discipline
- Prefer L0/L1 overviews before loading L2 detail.
- Retrieve by deterministic URI first, semantic search second.
- Use indexed upstream roots for profile overlays before broad repo-wide search.
- If retrieval paths become noisy, tighten directory structure before adding more memory.

## Memory-aware done standard
Work is not done until:
1. the deliverable exists,
2. validation is attached,
3. the relevant memory record is written,
4. indexed dependencies are discoverable when they should be,
5. and downstream retrieval paths are clear.
