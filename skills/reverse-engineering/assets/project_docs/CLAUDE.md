# CLAUDE.md — Documentation Set Writing/Analysis Guide

This folder (`docs/`) is a **project documentation set template**. It defines the procedures and rules for Claude (AI) when filling in or updating this set.

> **The single source of rules is [`00.INDEX.md`](00.INDEX.md).** Document structure, frontmatter, per-topic SSOT, content rules, and file naming rules are all originated in the INDEX; this file covers only **how to execute those rules (work procedure)**. Read the INDEX first before working.

---

## 0. Required Checks Before Starting

1. Read [`00.INDEX.md`](00.INDEX.md) — Table of Contents · §Per-Topic SSOT · §Content Rules · §Frontmatter Conventions.
2. Confirm the target stack — Spring Boot / web (React/Next.js) / Tauri / Android. The mapping of 04·05·06·07 differs (INDEX §Table of Contents, stack table).
3. Decide the scale — which slim profile (compact / standard) to start with (INDEX §Slim Profiles).

---

## 1. Absolute Rules (never violate)

- **Follow the per-topic SSOT** — never write the same topic in two documents. The original lives in one place (INDEX §Per-Topic SSOT); the rest keep only a "details in [`NN.xxx.md`](NN.xxx.md)" link. In particular:
  - Naming conventions → only in `03`. Domain term names → `01`.
  - External interface contracts (API/command/Intent) → only in `05`.
  - Environment variable key list → only in `09`.
  - Build · verification pipeline → `10`, test execution → `11`.
  - Progress status · completion · Phase → only in `13`. **No time-stamped status pinning in 00–12** (§Content Rules).
- **09 is a fact sheet** — do not duplicate architecture/FE/BE/domain/naming/build content into 09. 09 holds only links + project-specific information (Scope · Tech Stack · folder tree · environment variables · Change Checklist · Troubleshooting).
- **Frontmatter symmetry** — when adding/removing a document, update adjacent documents' `related_to` **bidirectionally** together, and keep `type` consistent with the §Table of Contents category. 00 is an inbound hub (excluded from back-references); 13 is one-way.
- **Read before writing** — always read the current content before overwriting an already-filled document.
- **First authoring of 13 is future-only** — when filling the documentation set for the first time, do not reconstruct past completed work in `13.roadmap.md`. Write only the remaining backlog, future considerations, deferred decisions, and questions to verify.
- **Leave `_(TODO)_` when unsure** — never fill unverified fields with guesses; leave an `_(TODO — <what is needed>)_` placeholder instead.

---

## 2. Workflow (project analysis)

Whether the project is new or existing, the essence of the work is the same — **analyze the source and transfer facts/conventions into documents.** Proceed in a single flow.

1. **Understand behavior first** — if code exists, trace the call chains (entry point → result) of 1–2 representative scenarios.
   - **standard**: record the trace into `12` process-guide. This reveals layers, module boundaries, and key files.
   - **compact**: `12` isn't part of this profile — record the same trace into `02` architecture instead (the structure-discovery result is absorbed into the architecture doc).
   - (For a brand-new empty project, replace this step with establishing conventions.)
2. **Fill in profile-specific order.** Content sources for each document are in §3.
   - **standard**: `01`→`02`→`03` (Foundation) → `04`·`05` (framework · contracts) → `06`·`07` (layer conventions) → `09` fact sheet → `10`·`11` (build · tests).
   - **compact**: `09` (fact sheet — scope/stack/env first; its Current Structure links and Change Checklist depend on `02`/`03`/`10` and are finalized after those, not on this first pass) → `02` (architecture, incl. the call-chain trace from step 1) → `03` (coding rules) → `04` (framework) → `06` (UI) → `10` (build/ops) → `13` (roadmap).
   - **Feature domains** (project-specific features/subsystems such as payments · hw_interface · local_db) — copy `domains/_template.md` to `domains/<domain>-guide.md` and register it in §1 of `08.domains.md`. Do not assign numbers. (standard only — this step doesn't apply to compact.)
3. **Update `13` when adding features or planning.** When first authoring the documentation set, do not fabricate a history of past work — write only the backlog and future consideration items still remaining.
4. **Template cleanup (once, on application)** — after filling in content, **remove all template-only scaffolding** so only project documents remain:
   - The `> Template: …` notice block at the top of each document (a marker common to all documents). **However, `CLAUDE.md` (the writing guide) and `domains/_template.md` (the copy source for new domains) are scaffolds that remain in the project, so do not delete them.**
   - The INDEX's opening introduction block (`> This document is … template`, etc.) and the entire `## Template Usage Guide` section (including Slim Profiles).
   - Unused domain examples (example rows in `08.domains.md`, etc.).
   - **Prune, do not delete, the stack table under §Table of Contents** — keep your project's row and drop the others. §Domain Guide points at this table for the per-stack 06 / 07 mapping, so removing it outright leaves a dangling pointer.
   - Fill unsubstituted `<...>` with actual values, and leave `_(TODO)_` only for the unverified (no leaving empty placeholders or unsubstituted `<...>` behind).
   - **Verify: `grep -rn '> Template:' docs/ --exclude=CLAUDE.md --exclude=_template.md` returns 0 hits.** (`CLAUDE.md` · `domains/_template.md` are retained scaffolds and keep their markers, hence excluded.)

> **Write the "current facts (is)."** Record exactly what is observed in the code, and where no convention exists yet, record newly made decisions in the corresponding SSOT document (`02`/`03`, etc.). Do not guess for unverified fields — use `_(TODO)_`. Report improvement suggestions separately; do not mix them into the documents.

---

## 3. Sources per Document (where the content comes from)

| Document | Source / evidence |
| :--- | :--- |
| 01 glossary | Entity/type names, terms recurring in code |
| 02 architecture | Folder structure, import directions, state stores |
| 03 coding-rules | Linter/formatter configs, code observation (team decision if a new convention) |
| 04 framework-guide | Entry points · configuration · DI/routing/IPC code |
| 05 framework-api | Route · command · Intent definition sites |
| 06 frontend-guide | Component · state · fetching code |
| 07 backend-guide | service/repository · DB · external integrations |
| 08 domains (+ `domains/*.md`) | Vertical slices per feature domain — entities · state machines · domain rules |
| 09 project-guide | Dependency files (`package.json`/`Cargo.toml`/`build.gradle`), `.env`, folder tree |
| 10 build-ops-guide | Build scripts, CI configs, log locations |
| 11 test-guide | Test directories · runner configs |
| 12 process-guide | Call tracing from entry points |
| 13 roadmap | Updated when adding features/planning. First authoring excludes past completed work; backlog · future considerations only |

---

## 4. Completion Verification (check after documentation work)

- [ ] Does the filled content not violate §Per-Topic SSOT (if the same content exists in two places, collapse one into a link)?
- [ ] Do relative links within documents (`NN.xxx.md`) point to actual files (no broken links after number changes)?
- [ ] Does frontmatter `type` match the §Table of Contents category, and is `related_to` bidirectionally symmetric?
- [ ] Is 00–12 free of time-stamped status pinning (dates · Phases · completion · test IDs)?
- [ ] Are unverified items left as `_(TODO)_` rather than guesses?
- [ ] If documents were added/removed/renumbered, were the `00.INDEX.md` table of contents, `related_to`, and subsequent number shifts updated?
- [ ] **Template cleanup complete** — for a project application, are the `> Template:` notices, INDEX introduction, `## Template Usage Guide` section, and unsubstituted `<...>` gone (`grep -rn '> Template:' docs/ --exclude=CLAUDE.md --exclude=_template.md` returns 0 hits)? `CLAUDE.md` · `domains/_template.md` are retained.

> If redesign tracking is needed, `_v2`, `_v3` suffixes are allowed for design documents only (not applied to documents in this set).
