---
name: reverse-engineering
description: Copy the bundled project-docs template set (14 permanent guide docs + domains/) into the current project's docs/ and reverse-engineer the codebase into it — call-chain analysis first, then foundation/domain/operations docs. Choose the compact or standard profile at start. Also usable to bootstrap the doc set for a brand-new project.
---

# mak:reverse-engineering — Project Analysis into the Standard Doc Set

Bootstraps the project's `docs/` from the bundled template set at
`${CLAUDE_PLUGIN_ROOT}/skills/reverse-engineering/assets/project_docs/`,
then fills it by analyzing the codebase (reverse engineering) or by recording agreed conventions (new project).

The set's own rules live inside it:

- `project_docs/00.INDEX.md` — structure, per-topic SSOT, frontmatter conventions, content rules, profiles (the rulebook)
- `project_docs/CLAUDE.md` — the writing/analysis procedure (how to execute the rulebook)

This skill orchestrates: profile choice → copy → analyze/fill → template cleanup. The two files above are the SSOT for everything else — follow them, don't restate them.

Templates are in English. Fill content in the user's language (or the project's documented language policy), keeping the structure.

## Procedure

### 1. Confirm target and state

- Confirm the project root (default: current working directory).
- Check for existing guide documents — `docs/` content, plus obvious guide files elsewhere (e.g. a root-level ARCHITECTURE/CONTRIBUTING guide). If any exist, list them and **confirm with the user whether to merge** (merge / copy only missing files / abort). **Never overwrite an existing document without reading it first.**
- **On merge, this skill's doc-set format is the baseline** — migrate the existing documents' content into the set's structure (per-topic SSOT, numbering, frontmatter per `00.INDEX.md`), not the other way around. Facts already written in the existing guides are treated as source material for step 4 (verify against code before carrying over; unverifiable claims become `_(TODO)_`). After migration, list the superseded originals and let the user decide whether to archive or delete them — do not delete on your own.

### 2. Choose a profile

Ask the user (recommend based on project size):

| Profile | Docs copied | Fits |
| :--- | :--- | :--- |
| **compact** | `00` `02` `03` `04` `06` `09` `10` `13` + `CLAUDE.md` (8 docs + guide) | solo / small single-stack apps |
| **standard** | `00`–`13` all + `CLAUDE.md` + `domains/` (incl. `_template.md`) | production / multi-domain / teams |

(Rationale and promotion path: `00.INDEX.md` §Slim Profiles.)

### 3. Copy the set

- Copy the chosen files from `${CLAUDE_PLUGIN_ROOT}/skills/reverse-engineering/assets/project_docs/` into `<project>/docs/`.
- For standard, copy the `domains/` folder **recursively** (it holds `_template.md` — copying only top-level `*.md` loses it).
- If the project has no `README.md`, offer `${CLAUDE_PLUGIN_ROOT}/skills/reverse-engineering/assets/README.template.md` as an optional starting skeleton (separate decision; skip silently if the user doesn't want it).

### 4. Analyze and fill

Follow `docs/CLAUDE.md` §2 (single flow — the essence: trace 1–2 representative call chains into `12` first if code exists, then fill in dependency order `01→02→03 → 04·05 → 06·07 → 09 → 10·11`; feature domains go to `domains/<domain>-guide.md` via `_template.md`; `13` gets only future backlog, never reconstructed history).

**Delegation** — if the `mak:analyzer` agent is in the available agent list, delegate the analysis/filling to it in batches (following the dependency order above; e.g. `12` first, then Foundation docs, then layer/ops docs). Pass each batch: the project root, the assigned document list, a pointer to `docs/00.INDEX.md` + `docs/CLAUDE.md` as the rulebook, and the output language. Keep interactive decisions (profile choice, overwrite confirmations, ambiguous conventions needing user input) in the main thread, and apply the cross-document syncs (e.g. `00.INDEX.md` tables, `related_to` symmetry) that analyzer reports back. If analyzer is unavailable, fill directly.

Hard rules while filling (SSOT: `docs/CLAUDE.md` §1):

- Record observed **facts (is)**, not aspirations; unverified cells get `_(TODO — <what's needed>)_`, never guesses.
- Respect per-topic SSOT — one home per topic, links elsewhere.
- Keep frontmatter `type` / `related_to` symmetric per the INDEX rules.
- No time-stamped status outside `13`.

### 5. Template cleanup + verification

Run the cleanup and the completion checklist exactly as defined in `docs/CLAUDE.md` §2 step 4 and §4 (remove `> Template:` blocks except in `CLAUDE.md`/`_template.md`, remove the INDEX usage section, no unreplaced `<...>`, grep check zero hits).

### 6. Report

Summarize: profile, files created, docs filled vs left `_(TODO)_`, and suggested next steps (e.g. fill remaining TODOs, or enter `mak:roadmap-planning` to shape `13`).

## Cautions

- This skill writes **documents only** — no source-code changes.
- Large analysis can be staged: agree with the user on which docs to fill this session and record the rest as `_(TODO)_`.
- Do not run git commit/push unless the user explicitly says "commit"/"push".
