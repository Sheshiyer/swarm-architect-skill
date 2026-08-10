---
name: "Agent-ready task"
about: "A well-scoped unit of work Copilot coding agent (or a human) can execute end-to-end."
title: "[task] "
labels: ["agent-ready"]
assignees: []
---

<!--
  This issue template enforces the contract the orchestrator expects before
  routing a task to `copilot-swe-agent[bot]`. All sections are required.
  Keep the issue to one branch / one PR of work — Copilot cannot fan out.

  Tip: if you cannot fill in "Acceptance criteria" with a concrete, testable
  statement, the task is not yet scoped enough for an agent — keep it human.
-->

## Goal

<!--
  One sentence. What will be true after this issue is closed?
  Good:  "Add rate limiting to the /api/login endpoint."
  Bad:   "Improve auth security."
-->

## Context

<!--
  Links to the spec, design doc, prior issue, or conversation that motivates
  this work. Paste the relevant quotes inline — the agent does not chase
  long link chains reliably.
-->

## Acceptance criteria

<!--
  Testable bullets. Each one must be verifiable from a diff, a passing test,
  or a log line. At least one criterion should be a concrete test name the
  PR adds or makes pass.
-->

- [ ] <criterion 1, testable>
- [ ] <criterion 2, testable>
- [ ] A test in `<path/to/test>` asserts the above and passes in CI.

## Files of interest

<!--
  The small set of paths the agent should read first. Copilot uses these as
  a starting context. Do not list the whole repo.
-->

- `<path/to/primary-file>`
- `<path/to/related-file>`

## Out of scope

<!--
  What this task must NOT touch. Prevents scope creep and long diffs.
-->

- <file/dir/feature explicitly off-limits>
- <refactors deferred to a follow-up>

## Dispatch notes

<!--
  Optional. For the human reviewer, not the agent.
  Examples: "Depends on #42", "Needs second reviewer from @security-team",
  "If the agent cannot satisfy criterion 3, fall back to human."
-->
