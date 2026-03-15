# Pairing Swarm Architect with Agency Agents

Use this guide when you want **Swarm Architect** to handle planning and orchestration while **agency-agents** supplies specialist execution profiles.

## Core Split
- **Swarm Architect** decides the plan structure: discovery, phases, waves, swarms, dependencies, validation gates, and GitHub synchronization.
- **Agency Agents** supplies specialist operating profiles for the execution of individual swarms.

Think of it as:
- Swarm Architect = **control plane**
- Agency Agents = **specialist workforce library**

## How to Use Them Together

### 1. Plan with Swarm Architect first
Create the full plan before selecting specialists.

Swarm Architect should define:
- task IDs
- dependencies
- owner roles
- owner agents
- validation criteria
- branch/worktree boundaries

### 2. Attach an execution profile to each swarm
Once the swarm exists, assign an agency profile to shape how that swarm should operate.

Examples:
- UI swarm → `engineering-frontend-developer`
- Backend swarm → `engineering-backend-architect`
- Infra swarm → `engineering-devops-automator`
- QA swarm → `testing-reality-checker` or `testing-api-tester`
- Architecture review swarm → `engineering-software-architect`

## Recommended Mapping

| Swarm concern | Runtime owner agent | Agency profile examples |
|---|---|---|
| Planning / orchestration | Claude | `specialized/agents-orchestrator`, `project-management/project-manager-senior` |
| UI / app implementation | Codex | `engineering/engineering-frontend-developer`, `design/design-ux-architect` |
| Backend / API | Copilot | `engineering/engineering-backend-architect`, `engineering/engineering-database-optimizer` |
| Infra / deployment | Copilot | `engineering/engineering-devops-automator`, `engineering/engineering-sre` |
| Validation / release gating | Gemini | `testing/testing-reality-checker`, `testing/testing-evidence-collector`, `testing/testing-api-tester` |
| Docs / packaging | Claude or Gemini | `engineering/engineering-technical-writer` |

## Suggested Schema Extension
You can keep runtime ownership concrete while adding specialist profile overlays.

Example task shape:

```json
{
  "id": "T-042",
  "owner_agent": "codex",
  "execution_profile": "agency/engineering-frontend-developer",
  "validation_profile": "agency/testing-reality-checker"
}
```

Use `execution_profile` for the specialist worker overlay and `validation_profile` for the specialist QA/release gate overlay.

## Good Use Cases

### Use agency-agents when you need:
- deeper domain guidance inside a swarm
- stronger role personality or deliverable style
- specialized review or validation behavior
- reusable specialist prompts across many repos

### Do not use agency-agents to replace:
- dependency modeling
- issue graph planning
- wave sequencing
- contract freeze decisions
- integration control

Those remain the job of Swarm Architect.

## Best Practice
Always assign the **plan first**, then the **specialist profile**.
If you choose specialists before the swarm boundaries are clear, overlapping responsibilities become much more likely.
