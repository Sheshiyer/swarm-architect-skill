# Copilot instructions

> Canonical instructions the Copilot coding agent reads on every session.
> Single repo-wide file, plain Markdown, no frontmatter.
> Replace `<placeholders>` with your project's real values before committing.

## Project

- **Name:** `<project-name>`
- **Purpose:** `<one-sentence-description>`
- **Repo role:** `<application | library | service | infra>`

## Stack

- Runtime: `<Bun 1.x | Node 20 | Python 3.12 | Go 1.22 | ...>`
- Framework: `<Next.js 15 | Fastify | FastAPI | ...>`
- Database: `<Postgres 15 | SQLite | ...>`
- Package manager: `<bun | pnpm | npm | uv | poetry | ...>`

## Build & verify

All commands below must pass before the agent marks a PR ready for review.

- Install: `<bun install>`
- Dev: `<bun dev>`
- Tests: `<bun test>` — required to pass on every PR
- Lint: `<bun run lint>`
- Typecheck: `<bun run typecheck>`
- Build: `<bun run build>`

## Conventions

- Indentation: `<2-space | 4-space>`; trailing newlines required.
- Imports: prefer named imports; avoid default exports for components.
- Errors: throw typed errors — never `process.exit`.
- Public APIs: document with JSDoc / docstrings.
- Tests: every new module ships with at least one happy-path test and one error-path test.

## File layout

- Application source: `src/`
- Tests: co-located next to source as `*.test.<ext>`
- Generated / build artifacts: `dist/`, `.next/`, `build/` — never edit by hand.

## Out of scope for the agent

The agent must refuse changes under these paths or stop and ask for direction:

- `infra/`, `terraform/`, `k8s/` — infrastructure is reviewed separately.
- `.github/workflows/copilot-*.yml` — Copilot plumbing itself; escalate.
- `.env*`, `secrets/`, any file named `*.key`, `*.pem`, `*.p12`.
- Database migrations that DROP or TRUNCATE tables.

## Safety rails

- Never commit secrets. If one exists in the diff, stop and surface it.
- Never add `.skip`, `.only`, or `xit` to tests. See `.github/instructions/tests.instructions.md`.
- Never disable lints or typechecks wholesale to make a build pass.
- When a test fails, fix the underlying code — do not weaken the assertion.
