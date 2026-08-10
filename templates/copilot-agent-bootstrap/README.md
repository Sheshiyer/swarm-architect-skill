# Target-repo bootstrap for Copilot coding agent

These six files make a **target repo** agent-ready — i.e., Swarm Architect (or any cooperating skill) can open an issue, apply the `agent-ready` label, and GitHub's Copilot coding agent (`copilot-swe-agent[bot]`) will pick it up and open a draft PR.

This directory holds **templates, not live config.** Copy them into a target repo's `.github/` tree. Nothing here runs inside Swarm Architect's own repo.

> A parallel canonical copy of these files lives in `Sheshiyer/github-next-wave-orchestrator` under `templates/.github/`. Both copies are kept in sync; changes must land in both. See the pinned constants table in `playbooks/copilot-coding-agent.md` §10.

## Contents

```
templates/copilot-agent-bootstrap/.github/
├── copilot-instructions.md              # repo-wide guidance the agent auto-reads
├── instructions/
│   └── tests.instructions.md            # path-scoped rail: no .skip / .only in tests
├── workflows/
│   ├── copilot-setup-steps.yml          # preinstall deps into the agent's VM
│   └── copilot-agent-dispatch.yml       # label → assign the bot
├── actions/
│   └── assign-copilot/
│       └── action.yml                   # composite action wrapping two GraphQL calls
└── ISSUE_TEMPLATE/
    └── agent-ready-task.md              # enforces the issue body contract
```

## Bootstrap procedure

Do these in the **target** repo (the one Copilot will work on), not this skill's repo.

### 1. Preflight — confirm Copilot is eligible

For personal Pro+ repos: nothing extra.

For org-owned repos (Business / Enterprise):

1. Enterprise admin has enabled third-party coding agents at the enterprise Agents page.
2. Org owner has enabled Copilot coding agent under **Settings → Copilot → Policies**. (Disabled by default.)
3. Target repo is opted in under the same settings page.
4. Issue author ≠ final PR approver (GitHub-enforced); identify a second reviewer up front.

If any check fails, stop — fix policy first. Copying templates before policy is green will produce a red dispatch workflow.

### 2. Copy the templates

From a checkout of the target repo:

```bash
# From inside the target repo root
mkdir -p .github/instructions .github/workflows .github/actions .github/ISSUE_TEMPLATE

# Pull the templates from this skill's repo (adjust path if vendored differently)
SKILL_REPO="/path/to/swarm-architect-skill"

cp "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/copilot-instructions.md"            .github/
cp "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/instructions/tests.instructions.md" .github/instructions/
cp "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/workflows/copilot-setup-steps.yml"  .github/workflows/
cp "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/workflows/copilot-agent-dispatch.yml" .github/workflows/
cp -r "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/actions/assign-copilot"          .github/actions/
cp "$SKILL_REPO/templates/copilot-agent-bootstrap/.github/ISSUE_TEMPLATE/agent-ready-task.md" .github/ISSUE_TEMPLATE/
```

### 3. Customize `copilot-instructions.md`

Replace every `<placeholder>` with your real stack, build commands, and out-of-scope directories. The agent reads this on every session — a generic file produces generic PRs.

### 4. Customize `copilot-setup-steps.yml`

Pick the stack block (Bun / pnpm / Python / etc.) that matches your repo and delete the others. Verify `timeout-minutes` is ≤ 59 (GitHub's hard cap for this workflow).

### 5. Create the PAT and store it as a repo secret

The default `GITHUB_TOKEN` **cannot** assign the Copilot bot (HTTP 422). A PAT is mandatory.

- Create a **fine-grained PAT**. Repository access: only the target repo(s).
  Permissions: `Actions (Read & write)`, `Contents (Read & write)`, `Issues (Read & write)`, `Pull requests (Read & write)`, `Metadata (Read)`.
- Billing attaches to the PAT owner's Copilot seat — the owner needs Copilot Pro+ / Business / Enterprise.
- Save it as the repo secret `COPILOT_ASSIGN_PAT` (**Settings → Secrets and variables → Actions → New repository secret**).

### 6. Create the two labels

```bash
gh label create agent-ready   --color 0E8A16 --description "Route this issue to copilot-swe-agent[bot]"  --repo <owner>/<repo>
gh label create agent-blocked --color B60205 --description "Never route this issue to any AI agent"      --repo <owner>/<repo>
```

### 7. Commit, push, verify

```bash
git add .github/
git commit -m "chore: add Copilot coding agent bootstrap"
git push
```

Verify the setup workflow runs cleanly once via **Actions → Copilot Setup Steps → Run workflow**.

### 8. Smoke test

Open a small, well-scoped issue using the **Agent-ready task** template. It comes pre-labeled `agent-ready`, so the dispatch workflow fires on issue creation. Within a minute or two:

- The dispatch workflow's run should be green.
- The issue should show `copilot-swe-agent[bot]` as an assignee.
- A draft PR should appear, authored by `copilot-swe-agent[bot]`, linking back to the issue.

If any of those are missing, read the dispatch workflow run log — common causes are PAT scope mismatch, the bot not being returned by `suggestedActors` (policy issue), or `agent-blocked` also being applied.

## Related

- `playbooks/copilot-coding-agent.md` — the autonomous operating model (rules, disambiguation from IDE-assist Copilot, quirks).
- `runbooks/route-to-copilot-agent.md` — how Swarm Architect dispatches an issue after the target repo is bootstrapped.
- `playbooks/github-sync.md` — the broader label taxonomy, including the disambiguation between `agent:copilot` (human + IDE) and `agent-ready` (autonomous bot).

## Pinned contract

| Constant | Value |
|---|---|
| Bot login | `copilot-swe-agent[bot]` |
| Opt-in label | `agent-ready` |
| Opt-out label | `agent-blocked` |
| PAT secret name | `COPILOT_ASSIGN_PAT` |
| Setup-workflow job name | `copilot-setup-steps` |
| Required issue body sections | `### Goal`, `### Context`, `### Acceptance criteria`, `### Files of interest`, `### Out of scope` |

Changes to any of these strings must land here, in `playbooks/copilot-coding-agent.md`, and in the sibling copy under `Sheshiyer/github-next-wave-orchestrator/templates/` simultaneously.
