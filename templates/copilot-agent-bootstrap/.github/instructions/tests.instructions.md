---
applyTo: "**/*.test.ts,**/*.test.tsx,**/*.test.js,**/*.spec.ts,**/*.spec.tsx,**/*.spec.js,**/*_test.py,**/test_*.py"
---

# Test discipline

These rules apply to every test file. The Copilot coding agent must follow them before opening or updating a PR.

## No skips, no onlys

- Do not add `.skip`, `xit`, `xdescribe`, `.only`, `fit`, or `fdescribe` to any test.
- Do not replace a failing test with a passing stub, a commented-out test, or a `// TODO`.
- If a test legitimately cannot pass in CI yet (e.g., it exercises a staging-only endpoint), do not write it in this repo — put the skeleton in a TODO issue and add a link in the PR body.

## Fix the code, not the test

- When a test fails: read the assertion, read the code under test, find the mismatch in the code, correct the code.
- Weakening an assertion (`.toBeTruthy` where `.toEqual(3)` was specified) is a regression. Do not do this without an explicit human instruction in the PR body.
- Deleting a test to make CI green is a regression. Do not do this.

## Coverage expectations

- New code of non-trivial size (>10 lines of runtime logic) ships with at least one happy-path test and one error-path test.
- Bug fixes ship with at least one regression test that fails on the old code and passes on the new code.

## Determinism

- No wall-clock dependencies: use injectable clocks / `vi.useFakeTimers()` / `freezegun`.
- No network calls to third parties: mock at the HTTP client boundary or use an in-process fake.
- No reliance on file-system ordering: sort before asserting.

## Reporting

- If you cannot satisfy these rules for a specific task, stop and explain in the PR body why. Do not ship a PR with disabled or deleted tests and a green CI.
