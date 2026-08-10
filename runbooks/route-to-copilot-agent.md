# Runbook: Route an Issue to the Copilot Coding Agent

Use this runbook after `runbooks/plan-to-github.md` has materialized a plan into GitHub issues, when one or more of those issues carry `copilot_eligible: true` in the originating task.

## When to use
- The plan contains tasks with `copilot_eligible: true`.
- The corresponding GitHub issues have been created using `templates/github-issue-template.md`.
- The target repository is already **Copilot-bootstrapped** (see `playbooks/copilot-coding-agent.md` §5), or the planner is prepared to bootstrap it first.

## Required inputs
- Target repo (`owner/name`).
- List of issue numbers that should be routed to `copilot-swe-agent[bot]`.
- Confirmation that the repo holds the `COPILOT_ASSIGN_PAT` secret.
- A named second reviewer for the resulting draft PRs.

## Preflight — must all be green

Before applying any label, confirm:

1. `playbooks/copilot-coding-agent.md` has been loaded.
2. Each candidate issue's body follows the Goal / Context / Acceptance criteria / Files of interest / Out of scope contract (see `templates/github-issue-template.md`).
3. The target repo contains `.github/workflows/copilot-agent-dispatch.yml` on its default branch (`gh api repos/{owner}/{name}/contents/.github/workflows/copilot-agent-dispatch.yml` returns 200).
4. The `agent-ready` label exists on the target repo (`gh label list --repo <owner>/<name> | grep agent-ready`). If not, create it and its counterpart `agent-blocked`.
5. For org-owned repos on Business/Enterprise: the Copilot coding agent policy is enabled at the org level and the target repo is opted in.
6. No candidate issue carries the `agent-blocked` label.

If any check fails, **stop**. Do not label. Surface the failing check to the planner and fall back to the human lane for those issues.

## Steps

1. Load `playbooks/copilot-coding-agent.md`.
2. For each candidate issue, verify the body contract one more time — reject the issue for dispatch if any required section is empty or placeholder-only.
3. Apply the `agent-ready` label:
   ```bash
   gh issue edit <issue-number> \
     --repo <owner>/<name> \
     --add-label agent-ready
   ```
   Do not set the assignee from this session. Assignment happens inside the target repo's workflow, which holds the PAT.
4. Watch for the dispatch workflow run:
   ```bash
   gh run list --repo <owner>/<name> \
     --workflow "Copilot agent dispatch" \
     --limit 5
   ```
   A successful run adds `copilot-swe-agent[bot]` as an assignee to the issue and posts a `🤖 Dispatched...` comment.
5. Confirm assignment:
   ```bash
   gh api repos/<owner>/<name>/issues/<issue-number> \
     --jq '.assignees[].login'
   ```
   Expect exactly `copilot-swe-agent[bot]` in the output. If not, read the dispatch run log (`gh run view <run-id> --repo <owner>/<name> --log`) and fix the cause before retrying.
6. When the agent opens a draft PR (usually within 1–5 minutes), record the PR number against the originating task. For iteration, use `@copilot <instruction>` comments on the PR.
7. Post a wave-sync comment on the originating issue (if not the same as the dispatch comment) summarizing what was routed and who the second reviewer is.

## Outputs
- Confirmed `agent-ready` label on each routed issue.
- Confirmed `copilot-swe-agent[bot]` assignment.
- Draft PR numbers captured back in the plan.
- A Dispatch Readiness line added to the wave summary: `Dispatch: X human · Y copilot · Z blocked`.

## Verification checklist
- Preflight all green before any label applied.
- Zero `agent-blocked` issues routed.
- Zero issues without the required body sections routed.
- One draft PR opened per routed issue within 10 minutes.
- No PATs, no secrets, no sensitive tokens appear in any comment or log this runbook produced.
- The second reviewer is named in the wave summary.

## Common failure modes
- **422 on assignment.** The target repo's PAT is wrong-scoped or the bot is not returned by `suggestedActors`. Confirm org policy, repo opt-in, and PAT permissions (Actions:RW, Contents:RW, Issues:RW, PRs:RW).
- **Dispatch workflow runs but does not assign.** Check the `assign-copilot` composite action logs — the `suggestedActors` query probably returned empty, meaning Copilot coding agent is not enabled for the bot within this repo/org.
- **Agent opens a PR that skips tests.** The repo is missing `.github/instructions/tests.instructions.md`. Land that file on `main` and re-route.
- **Agent closes the issue without a draft PR.** Scope was too ambiguous. Reopen the issue, tighten Acceptance criteria, and re-route only after the body passes the preflight again.
- **Two Copilots on one task.** Someone assigned a human Copilot-IDE role and also applied `agent-ready`. Remove the human owner or remove `agent-ready`; never both.

## Related
- `playbooks/copilot-coding-agent.md` — the operating model and rules.
- `playbooks/github-sync.md` — the broader label taxonomy.
- `runbooks/plan-to-github.md` — the prior runbook that created the issues.
- `templates/copilot-agent-bootstrap/` — target-repo setup package.
