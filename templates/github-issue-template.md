# GitHub Issue Template

Use this template when turning a plan task into a GitHub issue.

## Header
- **Issue title:** `[{{phase}}][{{wave}}][{{swarm}}] {{task_id}} — {{title}}`
- **Labels:** `phase:{{phase}}`, `wave:{{wave}}`, `swarm:{{swarm}}`, `area:{{area}}`, `agent:{{owner_agent}}`
- **Assignee / owner:** `{{owner_role}}`

## Body
### Context
- **Task ID:** `{{task_id}}`
- **Phase:** `{{phase}}`
- **Wave:** `{{wave}}`
- **Swarm:** `{{swarm}}`
- **Area:** `{{area}}`
- **Primary owner agent:** `{{owner_agent}}`
- **Owner role:** `{{owner_role}}`
- **Estimated hours:** `{{est_hours}}`

### Deliverable
{{deliverable}}

### Acceptance
{{acceptance}}

### Validation
{{validation}}

### Dependencies
- Upstream task IDs: {{dependencies}}
- Blocking issues/PRs:
- Contract dependencies:

### Execution Envelope
- **Branch:** `{{branch}}`
- **Worktree:** `{{worktree}}`
- **Lock-zone files:**
- **Allowed edit surface:**
- **Explicitly out of scope:**

### Completion Protocol
When complete, comment with:
1. summary of changes,
2. validation evidence,
3. linked PR or commit,
4. any contract deviations,
5. handoff notes for downstream tasks.
