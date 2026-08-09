---
name: verify-checklist
description: Use immediately after completing an implementation or change, before reporting results. Defines the verification order (build/type check, lint, tests, format, manual scenarios) and how to respond to failures.
---

# Post-Change Verification Checklist

After completing any implementation step, verify in the order below before reporting results.

---

## Verification Order

> **Priority rule**: if the project's CLAUDE.md or README specifies verification commands, use those first. The order and example commands below are defaults.

### ① Build / Type Check

Catch compile and type errors first. If this step fails, later steps are meaningless.

Examples:

```
pnpm tsc --noEmit          # TypeScript type check
pnpm build                 # bundle build
cargo build                # Rust build
go build ./...             # Go build
mvn compile                # Java/Maven compile
```

### ② Lint

Check code style and static-analysis errors.

Examples:

```
pnpm lint                  # ESLint (Node/TS)
cargo clippy               # Rust clippy
golangci-lint run          # Go lint
```

### ③ Unit Tests

Confirm the changed logic does not break existing contracts.

Examples:

```
pnpm test                  # Jest / Vitest etc.
cargo test                 # Rust tests
go test ./...              # Go tests
mvn test                   # Java/Maven tests
yarn test                  # Yarn projects
```

### ④ Format

Check formatting consistency. **Format only the files you changed** — project-wide reformatting inflates the diff and conflicts with the Precise Changes principle. Skippable if CI already enforces it.

Examples:

```
pnpm prettier --write <changed files>   # Prettier (JS/TS/MD)
cargo fmt -- <changed files>            # Rust format
gofmt -w <changed files>                # Go format
```

### ⑤ Manual Scenario (UI changes only)

Only applies when UI or user interaction changed.

- If manual verification is possible in this environment, run the scenario directly and report the result.
- If not possible (CI-only, remote build, etc.), report explicitly: **"Manual verification not possible — needs direct confirmation."** Never hide the inability to verify.

---

## On Failure

| Step | Action on failure |
| :--- | :--- |
| ① Build/type errors | Read the full error log, fix, re-run from ① |
| ② Lint errors | Auto-fix if available (`--fix` etc.); otherwise fix manually and re-run |
| ③ Test failures | Analyze the failing case and message; decide whether the implementation or the test is wrong, then fix |
| ④ Format errors | Run the format command, inspect changed files; report any unintended changes |
| ⑤ Manual scenario | Record the deviation concretely, fix, re-verify |

---

## Handoff

Verification never decides the next stage on its own — report the results and let the main thread route.

| Outcome | Next |
| :--- | :--- |
| A step failed | Fix and re-run from ①. If the fix is non-trivial and the `mak:coder` agent is in the available agent list, delegate it. If the failure exposes a design mismatch or a scope expansion, stop and report instead of fixing |
| All passed, slice/stage complete | Hand off to `mak:review-report` (or the `mak:reviewer` agent if it is in the available agent list) |
| All passed, work continues | Return to the main thread — it decides the next step |

Never route into `mak:commit` from here. Committing requires the user's explicit request.

---

## Prohibited Commands / Cautions

> If the project CLAUDE.md defines allowed/denied command lists, those take precedence. Below are general principles.

- `npx <command>`, `npm run <script>` — if the project uses pnpm/yarn, use that package manager
- `node_modules/.bin/<tool>` — use package-manager scripts instead of direct paths
- Prefer platform-independent commands (package-manager scripts, task runners) over OS-specific shell invocations (`cmd.exe /c ...`, `powershell.exe -Command ...`). When an OS-specific command is unavoidable, note both platform forms (`cp` / `Copy-Item`, etc.)
- `git commit`, `git push` — only when the user explicitly says "commit"/"push". Otherwise the user runs these directly
- Never report "done" before confirming verification results

---

## Self-Check Before Reporting

Ask yourself the following before writing the verification report. Clean up simple items caused by your own change before reporting. Do not silently fix scope expansions, design mismatches, or items needing user decisions — report them to the main thread instead.

- [ ] Does every changed line connect directly to the user's request? (Precise Changes)
- [ ] Did any unrequested "improvement" of adjacent code/comments/formatting slip in? (Precise Changes)
- [ ] Are all unused imports/variables/functions introduced by your change cleaned up? (Precise Changes)
- [ ] Were unrequested features / speculative flexibility / impossible-scenario error handling added? (Simplicity)
- [ ] Are all items in the design doc §5.0 success criteria or `Step → verify` table actually met? (Goal-driven)

## Report Format

After verification, report in this format (render headings in the user's language):

```
## Verification Results

| Step | Command | Result |
| :--- | :--- | :--- |
| ① Build/type check | `<command run>` | ✅ pass / ❌ fail |
| ② Lint | `<command run>` | ✅ pass / ❌ fail |
| ③ Unit tests | `<command run>` | ✅ pass / ❌ fail |
| ④ Format | `<command run>` | ✅ pass / ⏭ skipped |
| ⑤ Manual scenario | — | ✅ confirmed / ⚠️ not verifiable |

## Predefined Success Criteria vs Results

| # | Step (design doc §5.0) | Success criterion | Actual result |
| :- | :--- | :--- | :--- |
| 1 | <Step> | <verify> | ✅ met / ❌ not met |
| 2 | <Step> | <verify> | ✅ met / ❌ not met |
```

If the design doc has no `Step → verify` table, replace the second table with a one-line statement of whether the success criterion was met.

When all steps pass and all criteria are met: `✅ All verification steps and success criteria passed`
