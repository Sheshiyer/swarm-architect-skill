# Pairing Swarm Architect with OpenViking

Use this guide when you want **Swarm Architect** to handle orchestration and **OpenViking** to serve as the shared context and memory plane for the entire swarm.

## Core Split
- **Swarm Architect** decides the execution structure: discovery, phases, waves, swarms, ownership, GitHub sync, and validation gates.
- **OpenViking** stores and retrieves durable context: project memory, task memory, swarm memory, validation memory, and extracted lessons.

Think of it as:
- Swarm Architect = **control plane**
- OpenViking = **memory plane**

## Why this pairing works
OpenViking already solves:
- fragmented context,
- tiered context loading,
- directory-recursive retrieval,
- observable retrieval trajectories,
- and automatic session memory extraction.

Swarm Architect already solves:
- decomposition,
- multi-agent boundaries,
- issue/worktree ownership,
- and wave-gated execution.

Together they give you a swarm that can both **coordinate** and **remember**.

## Recommended URI layout
Mirror the Swarm Architect structure in OpenViking.

```text
viking://
├── resources/
│   ├── projects/
│   │   └── <repo>/
│   │       ├── specs/
│   │       ├── architecture/
│   │       ├── docs/
│   │       └── code-index/
│   └── upstreams/
│       ├── agency-agents/
│       └── impeccable/
└── agent/
    └── memories/
        └── swarms/
            └── <repo>/
                ├── planning/
                │   ├── discovery/
                │   ├── assumptions/
                │   └── phase-map/
                ├── phases/
                │   └── P1/
                │       └── W1/
                │           ├── swarm-ui/
                │           ├── swarm-api/
                │           └── swarm-qa/
                ├── tasks/
                │   └── T-001/
                ├── handoffs/
                ├── validations/
                └── lessons/
```

## Memory scopes
Use one of these scopes per task or planning artifact:
- `project`
- `planning`
- `phase`
- `wave`
- `swarm`
- `task`
- `validation`
- `lesson`

## Upstream resource roots
When bootstrap has prepared upstream visibility, use these as the default resource roots:
- `viking://resources/upstreams/agency-agents`
- `viking://resources/upstreams/impeccable`

These roots are intended to become the stable OpenViking-facing identities for the cloned upstream repos, even before full ingestion automation exists.

## Suggested task shape
```json
{
  "id": "T-042",
  "owner_agent": "codex",
  "execution_profile": "agency/engineering-frontend-developer",
  "quality_profile": "impeccable/polish",
  "validation_profile": "agency/testing-reality-checker",
  "memory_scope": "task",
  "memory_uri": "viking://agent/memories/swarms/openviking/tasks/T-042",
  "memory_inputs": [
    "viking://resources/projects/openviking/architecture/.overview",
    "viking://agent/memories/swarms/openviking/phases/P2/W3/swarm-ui/.overview"
  ],
  "memory_outputs": [
    "completion-summary",
    "validation-evidence",
    "handoff-note"
  ]
}
```

## What to store where

### Project baseline memory
Store once, retrieve often:
- specs
- architecture summaries
- issue taxonomy
- rollout constraints
- branch/worktree rules

### Wave memory
Store per wave:
- objective
- included tasks
- ownership split
- contract baseline
- wave-close summary

### Swarm memory
Store per swarm:
- scope
- allowed edit surface
- blocked surfaces
- contracts consumed
- contracts produced
- active blockers

### Task memory
Store per task:
- summary of work
- PR/issue links
- decision log
- validation evidence
- residual risks
- handoff notes

### Validation memory
Store:
- defect summaries
- regression findings
- release gate outcomes
- unresolved risk notes

## Best practice
Make memory paths deterministic.
If the plan says `P2/W3/swarm-ui/T-042`, the memory path should reflect that exactly. This makes retrieval auditable and predictable instead of magical.
