# CLAUDE.md — Documentation Set Analysis Guide

This folder (`docs/`) is a **project documentation set template**, filled by reverse-engineering the existing code base. It defines the procedures and rules for Claude (AI) when filling in or updating this set.

> **The single source of rules is [`00.INDEX.md`](00.INDEX.md).** Document structure, frontmatter, per-topic SSOT, content rules, and file naming rules are all originated in the INDEX; this file covers only **how to execute those rules (work procedure)**. Read the INDEX first before working.

---

## 0. Required Checks Before Starting

1. Read [`00.INDEX.md`](00.INDEX.md) — Table of Contents · §Per-Topic SSOT · §Content Rules · §Frontmatter Conventions.
2. Confirm the target stack — Spring Boot / web (React/Next.js) / Tauri / Android. The mapping of 04 · 05 · 06 differs (INDEX §Table of Contents, stack table).

---

## 1. Absolute Rules (never violate)

- **Follow the per-topic SSOT** — never write the same topic in two documents. The original lives in one place (INDEX §Per-Topic SSOT); the rest keep only a "details in [`NN.xxx.md`](NN.xxx.md)" link. In particular:
  - Naming conventions and domain term names → only in `03` §2.
  - External interface contracts (API/command/Intent) → only in `04` §5 Contract Catalog.
  - Environment variable key list → only in `01` §4.
  - Build · verification pipeline · test execution → only in `06`.
  - Call chains → only in `processes/<name>.md`; feature-domain rules → only in `domains/<name>.md`.
- **01 is a fact sheet** — do not duplicate architecture/layer/domain/naming/build content into 01. 01 holds only links + project-specific information (Scope · Tech Stack · directory tree · entry points · environment variables · Change Checklist · Troubleshooting).
- **Frontmatter symmetry** — when adding/removing a core document, update adjacent documents' `related_to` **bidirectionally** together, and keep `type` consistent with the §Table of Contents category. 00 is an inbound hub (excluded from back-references); `domains/` · `processes/` files are one-way leaves.
- **Read before writing** — always read the current content before overwriting an already-filled document.
- **No time-stamped status anywhere in the set** — no dates · Phases · completion marks · test IDs (INDEX §Content Rules). A roadmap, if the project keeps one, is a separate document outside the set.
- **Leave `_(TODO)_` when unsure** — never fill unverified fields with guesses; leave an `_(TODO — <what is needed>)_` placeholder instead.

---

## 2. Workflow (project analysis — steps 1–2 may be delegated; steps 3–4 stay with the main thread)

The essence of the work is **analyzing the source and transferring observed facts into documents.** Proceed in a single flow.

1. **Understand behavior first** _(delegable)_ — trace the call chains (entry point → result) of 1–2 representative scenarios. For each scenario, copy `processes/_template.md` to `processes/<name>.md` and record the trace there. This reveals layers, module boundaries, and key files, which the following steps describe.
2. **Fill the core documents, then the domains** _(delegable)_ — content sources for each document are in §3:
   - `01` overview — Scope · Tech Stack · directory tree · entry points · environment variables first. Its §5 Change Checklist and §6 Troubleshooting depend on `03`/`04`/`06` and are finalized last, not on this first pass.
   - `02` architecture → `05` layers → `03` conventions → `04` framework (incl. §5 Contract Catalog) → `06` build-ops.
   - **Feature domains** — for each project-specific feature/subsystem discovered while tracing (payments · hw_interface · local_db · …), copy `domains/_template.md` to `domains/<name>.md` and fill it. Do not assign numbers.
   - Finalize `01` §5 · §6.
3. **Synchronize the index** _(main thread)_ — register every `domains/` · `processes/` file in `00.INDEX.md` §Domains / §Processes, and check `related_to` symmetry among `01`–`06`.
4. **Template cleanup (once, on application)** _(main thread, never a delegated agent)_ — after filling in content, **remove all template-only scaffolding** so only project documents remain:
   - The `> Template: …` notice block at the top of each document (a marker common to all documents). **However, `CLAUDE.md` (this guide), `domains/_template.md`, and `processes/_template.md` are scaffolds that remain in the project, so do not delete them, nor the notices inside the two `_template.md`.**
   - The INDEX's opening introduction block (`> This document is … template`, etc.), and retitle its H1 from `Documentation Index — Shared Template (template)` to `Documentation Index — <project-name>`.
   - **Prune, do not delete, the stack table under INDEX §Table of Contents** — keep your project's row and drop the others (§Category Guide points at this table for the per-stack 05 mapping). Delete its `_(At template cleanup, …)_` line.
   - The example rows in INDEX §Domains / §Processes and their `> Template:` notices — only real, registered files remain (an empty registry keeps one `_(TODO)_` row).
   - Fill unsubstituted `<...>` with actual values, and leave `_(TODO)_` only for the unverified (no leaving empty placeholders or unsubstituted `<...>` behind).
   - **Verify: `grep -rn '> Template:' docs/ --exclude=CLAUDE.md --exclude=_template.md` returns 0 hits.** (`CLAUDE.md` · the two `_template.md` are retained scaffolds and keep their markers, hence excluded.)

> **Write the "current facts (is)."** Record exactly what is observed in the code. Do not guess for unverified fields — use `_(TODO)_`. Report improvement suggestions separately (in the final report); do not mix them into the documents.

---

## 3. Sources per Document (where the content comes from)

| Document | Source / evidence |
| :--- | :--- |
| `processes/<name>.md` | Call tracing from entry points (routes · handlers · commands · main) |
| 01 overview | Dependency files (`package.json`/`Cargo.toml`/`build.gradle`), `.env*`, folder tree, bootstrap code |
| 02 architecture | Folder structure, import directions, state stores, module boundaries seen in step 1 |
| 03 conventions | Linter/formatter configs, code observation, recurring entity/type names |
| 04 framework | Entry points · configuration · DI/routing/IPC code; route · command · Intent definition sites (→ §5) |
| 05 layers | Component · state · fetching code (UI); service/repository · DB · external integrations (core) |
| 06 build-ops | Build scripts, CI configs, test directories · runner configs, log locations |
| `domains/<name>.md` | Vertical slices per feature domain — entities · state machines · domain rules |

---

## 4. Completion Verification (the main thread checks this after documentation work)

- [ ] Does the filled content not violate §Per-Topic SSOT (if the same content exists in two places, collapse one into a link)?
- [ ] Do relative links within documents (`NN.xxx.md`, `../NN.xxx.md`, `domains/…`, `processes/…`) point to actual files?
- [ ] Does frontmatter `type` match the §Table of Contents category, and is `related_to` bidirectionally symmetric among `01`–`06` (00 hub / leaf folders one-way excepted)?
- [ ] Is the whole set free of time-stamped status pinning (dates · Phases · completion · test IDs)?
- [ ] Are unverified items left as `_(TODO)_` rather than guesses?
- [ ] Do the `00.INDEX.md` tables (§Table of Contents · §Domains · §Processes) match the actual files in `docs/`, `domains/`, `processes/`?
- [ ] **Template cleanup complete** — are the `> Template:` notices, the INDEX introduction, the example registry rows, and unsubstituted `<...>` gone (`grep -rn '> Template:' docs/ --exclude=CLAUDE.md --exclude=_template.md` returns 0 hits)? `CLAUDE.md` · `domains/_template.md` · `processes/_template.md` are retained.
