---
name: commit
description: Wrap up completed work with a git commit — invoke when the current changes should be committed. Invoking this skill IS the explicit commit request required by the kit's git policy, and it covers the commit only (push/amend/rebase still need their own explicit request). Procedure details are in the body.
---

# mak:commit — Work Wrap-Up and Commit

Running this skill is the user's explicit "commit" instruction — for the commit only. Push, amend, rebase, reset, force operations, and tags run only when the user explicitly asks for that specific operation.

## Procedure

### 1. Inspect

`git status` + `git diff` (staged / unstaged / untracked). Nothing to commit → report and stop. Identify which task the changes belong to.

### 2. Gates

Results are reported once, in the §5 report. Surface immediately only findings that need a user decision (split proposal, unverified proceed, suspected secret).

- **Verification** — confirm the changes were verified (`mak:verify-checklist` results or the project's verify commands). Not verified with a runtime surface → run the checks now **without any auto-fix or formatter** (build/type check, lint without `--fix`, tests). Builds/tests may still produce artifacts (caches, build output, snapshots) — after running them, re-check `git status` and **never stage anything the verification produced**. If checks fail, do not fix anything here — either get explicit confirmation to proceed unverified, or stop and route the fix through the normal flow first, then re-enter this skill.
- **Precise changes** — one purpose per commit. Unrelated changes mixed in → propose a split or leave them unstaged; never bundle silently.
- **Hygiene** — exclude temp/junk files, logs, large binaries, and secrets. Never commit a suspected secret without asking, even if staged.

### 3. Stage deliberately

Stage the reviewed files explicitly; no blind `git add -A`.

### 4. Message

- Follow the repo's convention (recent `git log` style, commitlint) **only if it is consistent and informative**. If history is mostly placeholders ("update", "fix", "wip"), **or too thin/mixed to establish a deliberate convention (a handful of commits, no unified pattern)**, do not treat it as one — use the fallback below and note briefly why the history wasn't followed.
- Fallback and quality floor: Conventional Commits — `<type>(<scope>)?: <subject>`, imperative subject ≤ 72 chars. A repo convention may override the shape, never the informativeness.
- **Write the message in the user's conversation language** (or the project's documented language policy).

Type = the change's primary intent, not its file type:

| Type | Use for |
| :--- | :--- |
| `feat` | new or extended capability |
| `fix` | correcting wrong behavior |
| `refactor` | restructuring, no behavior change |
| `perf` | performance, no functional change |
| `test` | tests only |
| `docs` | documentation only |
| `style` | formatting only |
| `build` | build system / dependencies |
| `ci` | CI configs |
| `chore` | other maintenance (tooling, `.gitignore`, …) |
| `revert` | reverting a commit (reference it in the body) |

- **One type per commit** — two genuinely applying is a split signal (back to §2). Docs/tests belonging to a feat/fix ship inside it.
- Scope optional (module/domain; reuse scopes from `git log`). Breaking change: `!` + `BREAKING CHANGE:` body line.
- mak outputs: design doc / roadmap / doc-set → `docs`; a verify-caught fix before commit → part of the original `feat`/`fix`; kit/config housekeeping → `chore`.

**Style — concise and declarative, never narrative.** Every line carries a fact, not prose about the work:

- **Subject** — the outcome ("remove the cross-layer duplication"), not the mechanics ("move a file"). Imperative or noun phrase, no trailing period, ≤ 72 chars.
- **Body** — 2–6 bullets, **one line per bullet**, one verifiable fact each with counts/names. No paragraphs, no multi-sentence bullets, no prose connecting them.
- **Cut, always** — "this commit …" openers, background/motivation essays, restating the diff file by file, closing summaries, hedges ("slightly", "some"), and polite or past-tense sentence endings (in languages with such endings — e.g. Korean — use noun-phrase endings instead).
- **Keep** — preserved invariants (contract unchanged, tests moved along), what intentionally stayed put, doc-sync section names.
- **Scale the body to the diff** — a tiny change (a line or two, single concern) takes the subject alone or at most one bullet; multi-bullet bodies are for diffs with multiple facts worth recording.

The terseness rule holds in every language; only the wording changes with §Message's language rule. Example (imitate the structure, in the user's language):

```
refactor(order): remove OrderStatus duplication via the shared domain layer

- OrderStatus: features/checkout/model -> domain/order (serialization contract unchanged, 2 unit tests moved)
- payment/history references switched to the domain path — 1 cross-feature import exception removed
- OrderStatusDto stays in features/checkout (API response shape)
- Docs sync: architecture guide (§module tree, §exception list), glossary
```

### 5. Commit and report (at a glance)

Pre-commit self-check: the message body (logical view) and the staged files (physical view) **must agree** — a bullet with no supporting file, or a file no bullet accounts for, is a stop signal; resolve it before committing.

Commit (one per purpose; more if a split was agreed in §2), then report in the user's language:

```
## Commit Result
- <short hash> — <the committed message: subject and body>
- Gates: verification ✅/⚠️ · precise-changes ✅/⚠️ · hygiene ✅/⚠️

| File | +/− | What changed |
| :--- | :--- | :--- |

- Left uncommitted (intentionally): <files + reason, or "none">
- Not pushed — push runs only on the user's explicit request
```

Cluster long file lists into logical groups, but every file appears.

## Prohibitions

- No `push` / `--amend` / `rebase` / `reset` / force operations / tags on your own — each only on the user's explicit request for that operation.
- No commit with a failing or skipped verification gate without the user's explicit confirmation.
- No file edits by this skill itself — staging/unstaging and committing only; fixes go back through the normal flow. Artifacts incidentally produced by verification (caches, build output) are never staged or committed.
