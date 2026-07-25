---
name: major-feature-pack
description: Use for a large new-feature introduction or a port of a big process from another platform/language/stack, when the upfront analysis is too broad to track in one document — external/legacy system alignment, data-model matrices plus boundary contracts, or many independent policy decisions overlapping. Produces a structured 9-doc design pack. If the analysis fits one document (even for multi-PR / multi-module work), use mak:design-doc-template instead — PR/module count is NOT the criterion. Detailed entry criteria are in the skill body.
---

# Major Feature Pack Writing Guide

This skill writes a **structured design pack of 9 documents** in a consistent format,
applicable regardless of project / domain / tech stack.

Write pack documents in the user's language (or the project's documented language policy). The bundled templates are in English; keep their structure.

It covers two scenarios equally:

- **Migration**: porting a process from an existing / external system into the current project
- **New feature**: building a large feature / domain / integration from scratch

Templates: `${CLAUDE_PLUGIN_ROOT}/skills/major-feature-pack/assets/00-index.template.md` – `08-implementation-plan.template.md`

---

## Terms / Conventions

Terms used by this skill. Substitute project-specific words as needed.

| Term | Meaning | Alternatives |
| :--- | :--- | :--- |
| **pack** | This skill's unit — one structured design pack of 9 documents | feature pack / design pack |
| **origin** | The **existing / source system** in a migration scenario (e.g. legacy codebase / previous stack). Absent in new-feature scenarios — doc 02 then covers external specs / reference documents | source / legacy / upstream |
| **target** | The **current project** the pack applies to | current / new |
| **IS-N** | Known defects / recommended deviations of origin (only when origin documentation defines them — absent for new features) | Known Issue |
| **P-N** | Problems in current code identified by this design (assigned in `01-current-state-analysis.md`) | Problem |
| **D-N** | Policy decisions adopted by this design (assigned in `03-policy-decisions.md`) | Decision |

> "origin" is a generic noun for **source / starting point**, like git's `origin`. In new-feature scenarios origin can be an external SDK spec / standard RFC / product brief.

---

## When to Use

### Enter this skill

- **New feature**: a large feature spanning multiple modules (backend / interface contracts / frontend / data model / external APIs) whose analysis, policy, data model, and contracts must be **tracked separately**
- **Migration**: porting a process from an existing system (e.g. TypeScript / Java / Rust / Android / external SDK) into the current project
- Work whose analysis surface is broad enough that current state, policy, data model, and interface contracts need **separate tracked documents** (multi-PR alone is not the criterion — see the rule of thumb)
- Work with layered concerns: policy decisions / intentional deviations / security / compatibility

> **Rule of thumb**: the key question is *"does the upfront analysis fit in one document?"* External/legacy alignment (current vs spec gap + intentional-deviation matrix) · data-model matrix + both sides of a boundary contract · many independent policy decisions (TBDs) — when **several of these overlap** and one document can't track them, use this skill (9-doc).
> **Multi-PR / multi-module alone is NOT the criterion**: splitting a single concern across PRs (e.g. structural refactor) is handled by `mak:design-doc-template`'s **master doc (decisions, PR dependency graph) + per-PR sub-docs**.

### Route to a different skill when

- Single concern (analysis fits one document, even multi-PR) → `mak:design-doc-template` (master + per-PR sub-docs if needed)
- Project-wide phase structure / priorities / status tracking → `mak:roadmap-planning`
- Direction itself is vague and needs divergence → `mak:brainstorming`
- Kickoff of a single phase → `mak:dev-kickoff`

### Entry signals (examples)

- "Design the whole {{new domain}}" / "a design set introducing {{big feature}} from scratch"
- "Port module X from {{legacy stack}} to {{new stack}}"
- "Design docs for a large integration with {{external system / spec}}"
- "A migration moving the entire {{domain — payments / auth / comms / data sync}}"

---

<HARD-GATE>
This skill performs investigation and document writing only. No implementation or code modification.

Allowed: read-only investigation (Read / Grep / Glob / git log), creating/updating design documents (.md).
Prohibited: creating/modifying/deleting source code files; running build or execution commands.
</HARD-GATE>

---

## Pre-Investigation Checklist

Before writing the pack, confirm:

- [ ] **Scenario identified** — migration vs new feature (decides the directory prefix)
- [ ] **Primary sources identified** — for migration: origin specs / legacy code / external SDK docs; for new features: external specs / standards / product briefs. Note volume / section structure / known defects (IS-N)
- [ ] **Current project code state** — via `Read` / `Grep`: does the related module already exist, is it a placeholder stub, or absent
- [ ] **Prior pack / phase dependencies** — is another pack or phase a precondition
- [ ] **Items needing external review** — security, auth, external SDK licensing, ops policy: things the dev team can't decide alone
- [ ] **Existing pack documents** — if other packs exist, check naming / notation / cross-reference conventions

---

## The 9 Documents

| # | File | Role | Writing order |
| :-- | :--- | :--- | :--- |
| 00 | `00-index.md` | Overall scope / key-decision summary / intentional deviations / dependencies / index | **last** (after the other 8) |
| 01 | `01-current-state-analysis.md` | Current project analysis + gap vs origin + identified problems (P1–PN) | 2nd |
| 02 | `02-target-process-reference.md` | Origin / external spec summary — reorganized from this project's perspective | 1st |
| 03 | `03-policy-decisions.md` | Policy decisions (D1–DN) — option comparison + recommendation + TBD marks | 3rd |
| 04 | `04-data-model-design.md` | Data model (per-language types / storage-location matrix / prohibition matrix) | 4th |
| 05 | `05-backend-module-design.md` | Backend module structure / per-file changes / dependencies / test guide | 5th |
| 06 | `06-interface-contract-design.md` | Interface contract (choose: Tauri IPC / HTTP API / gRPC / FFI / module exports) — commands, events, types, sequences, error codes | 6th |
| 07 | `07-frontend-state-design.md` | Frontend types / api / mutations / components / security validation (if applicable) | 7th |
| 08 | `08-implementation-plan.md` | N implementation steps / PR split / automated checks / manual TCs / risks & mitigations | 8th |

> Natural order: **02 → 01 → 03 → 04 → 05 → 06 → 07 → 08 → 00**.
> 02 (origin / external spec) first — the baseline must be clear before judging the 01 gap.
> 00 (index) last — it summarizes / indexes / extracts key decisions from the other 8.

### Omitting documents when warranted

- No frontend (CLI / library / backend-only service) → omit `07-frontend-state-design.md`
- Single process / single module boundary → omit `06-interface-contract-design.md` (e.g. internal library refactor)
- New feature with no origin / current code to compare → the "origin vs current matrix" section of `01` may be omitted (keep the document — state the absence itself)

When omitting, record the reason in the document table of `00-index.md`.

---

## Procedure (in order)

### 1. Confirm scenario / primary sources / scope

Narrow intent with 1–3 questions:

- "Is this a **migration** (porting an existing system) or a **new feature** (built from scratch)? — decides the directory prefix (`mig_` vs `feat_`)"
- "Where are the primary source documents / code?"
- "Anything explicitly excluded from this pack's scope? (e.g. dead code / unused features / other pack tracks)"

### 2. Write 02-target-process-reference.md

Reorganize origin docs / code / external specs from this project's perspective. Include:

- Core components of the origin / external spec (summary)
- Spec tables (per domain — e.g. protocol fields / status codes / message schemas / API endpoints)
- Flows / sequences
- Equivalents / substitutions in this project's environment
- Intentional-deviation table vs origin (for migration; for new features, "intentional deviations vs external spec")

### 3. Write 01-current-state-analysis.md

After checking current code via `Read` / `Grep`:

- Current flow summary (for new features, state "no current code")
- Origin vs current matrix (when applicable)
- Per-component detail (3.1, 3.2, ...)
- Consolidated identified problems (P1–PN table) — for new features, write as "unimplemented areas"
- Mapping to origin Known Issues (IS-N) (when applicable)
- Prior work / pack dependencies

### 4. Write 03-policy-decisions.md

Write policy decisions D1–DN as option comparisons + recommendations. Structure per D item:

```markdown
## DN. {{decision title}}

### Question
{{what is being decided?}}

### Decision — **{{recommendation}}**
{{explanation}}

### Rationale
- {{rationale 1}}
- {{rationale 2}}

### Impact
- §05 {{module}}
- §06 {{interface contract — command / event / types}}

### TBD (optional)
- [ ] {{item needing external / ops review}}
```

End with an **ops review checklist** table — the user confirms or marks TBD per item.

### 5. Write 04-data-model-design.md

Define the data model. Include the storage-location matrix + prohibition matrix. Language/stack-agnostic — Rust structs / Java classes / TypeScript interfaces / proto messages / JSON schemas as fits the project.

### 6. Write 05-backend-module-design.md

Backend per-file changes / new modules / abstractions (trait / interface / abstract class) / dependencies / test guide. Build-system agnostic.

### 7. Write 06-interface-contract-design.md

The **interface contract** at the system boundary. Pick the form matching the project (Tauri IPC / HTTP API / gRPC / FFI / module exports) in the §0 scenario-mapping table, then write commands, events, types, sequences, error codes, and the compatibility checklist in that form.

### 8. Write 07-frontend-state-design.md

Frontend types / api / mutations (or equivalent patterns) / components / routing / security validation. Framework-agnostic (React / Vue / Svelte / Angular / native mobile / etc.).

### 9. Write 08-implementation-plan.md

Split into N steps + PR-split table + automated / manual verification + risks & mitigations + TC checklist.
Write verification commands for the project's build system (Cargo / npm / Maven / Gradle / Go / etc.).

### 10. Write 00-index.md (last)

Summarize / index the other 8. Key-decision one-line summary table + intentional-deviation table + dependencies / prerequisites / scope / workflow.

### 11. User approval

Report on completion. The D items / TBDs in 03 especially need user / external review.

---

## Consistency Conventions

### Directory naming — **two prefixes**

| Scenario | Prefix | Example directory | Meaning |
| :--- | :--- | :--- | :--- |
| Migration | `mig_` | `<docs-root>/<root>/mig_<topic>/` (e.g. `mig_auth_session`) | Port of an existing / external system |
| New feature | `feat_` | `<docs-root>/<root>/feat_<topic>/` (e.g. `feat_offline_sync`) | Large feature / domain / integration built from scratch |

Judgement:

- Primary source is **existing system code / spec** → `mig_`
- Primary source is **external SDK spec / RFC / product brief / brainstorming output** → `feat_`
- If ambiguous, ask the user

The root path follows project convention:

- `<docs-root>` e.g.: the project's design-doc path (default `.claude/mak/plan/` — see `mak:design-doc-template`), or `docs/`
- `<root>` e.g.: `origin-migration/`, `migration/`, `feature-design/`, or none

> Both prefixes may coexist under one root — e.g. `mig_payments/` next to `feat_offline_sync/`. Or split without prefixes: `migration/<topic>/` + `feature-design/<topic>/`.

### The 9 filenames

`00-index.md` – `08-implementation-plan.md` (two-digit prefix + kebab-case). Same for both scenarios.

For redesigns, a directory-level `<prefix>_<topic>_v2/` suffix is allowed.

### Primary-source directory

For migrations, keep origin documents in a separate path:

- e.g. `<docs-root>/origin-process/origin_<topic>/`
- or `<docs-root>/source/<topic>/`, or external links only

For new features, cite external specs / RFCs / briefs directly in doc 02.

### Cross-reference notation

When citing another pack document, use **full path + filename + section**. No short forms.

```markdown
> Sources (all under `<this pack's directory>`):
>
> - `03-policy-decisions.md` §D5 — {{short description of what's there}}
> - `04-data-model-design.md` §2.2 — {{what's there}}
> - `08-implementation-plan.md` Step 1 — {{what's there}}
```

### "Assumption" / "TBD" / "Unreviewed" notation

Mark unconfirmed facts and externally-decided items explicitly:

- **Assumption**: this design assumes `<XYZ>`. Verify during implementation.
- **TBD**: confirm after `<external team / ops / security>` review.
- **Unreviewed**: `<item>` was not examined.

### Intentional-deviation table

Where this design **differs** from origin / external spec, tabulate it. Reason column required.

```markdown
| Area | Origin / external spec | This design | Reason |
| :--- | :--- | :--- | :--- |
| {{area}} | {{original behavior}} | {{this design's behavior}} | {{one-line reason}} |
```

### Known-Issues mapping (when origin defines IS-N)

```markdown
| Origin IS-N | Handling in this design |
| :--- | :--- |
| IS-1 — {{magic number}} | Extract constant (`SOME_CONSTANT`) — §03 D7 |
| IS-3 — {{dead code}} | **Dropped** — not ported — §03 D8 |
```

Omit for new-feature scenarios / standard-spec citations.

### State "what this pack covers" / "does not cover"

In the `## Scope` section of `00-index.md`. Clearly separate items on other tracks / follow-up work.

---

## Core Principles

- **Align with origin / external spec by default**; tabulate only intentional deviations. No arbitrary variation.
- **Do not port dead paths** (code unused in production) — follow origin's Known Issues / recommendations.
- **Keep externally-decided items as TBD and keep moving** — don't stall on pending decisions.
- **State prior pack / phase dependencies** in both 00 and 01 — make preconditions explicit.
- **Security / sensitive data**: specify in doc 04 via storage-location matrix + prohibition matrix.
- **PR split** in doc 08 by regression risk and dependencies. Split PRs that grow too large.
- **Interface-contract changes** ship in the same PR as their callers (frontend / other services / library users) to avoid type breaks.

---

## Quality Checklist

Self-check after completing the pack:

- [ ] All 9 documents written (or omissions recorded with reasons)?
- [ ] Directory prefix (`mig_` / `feat_`) matches the scenario?
- [ ] 00's key-decision summary maps 1:1 to 03's D1–DN?
- [ ] 00's intentional-deviation table consistent with 02's?
- [ ] 01's P1–PN all referenced in the impact columns of 03 / 05 / 06?
- [ ] 03's ops review checklist covers every externally-decided item?
- [ ] 04's storage-location + prohibition matrices consistent with security policy?
- [ ] 05's change-impact table covers every new / modified file?
- [ ] 06's error-code table includes retryable policy + user messages?
- [ ] 06's scenario mapping matches this project's interface form?
- [ ] 07's security/validation checklist covers sensitive-data non-exposure?
- [ ] 08's PR split states regression risks / dependencies?
- [ ] All cross-references use full path + filename + section? (no short forms)
- [ ] All origin Known Issues (IS-N) mapped? (for migrations)
- [ ] "Assumption" / "TBD" / "Unreviewed" marked appropriately?

---

## Relationship to Other Skills

- **`mak:design-doc-template`** — each of the 9 docs is a variant of the design-doc format. If analysis fits one document (even multi-PR), use design-doc-template — multi-PR is handled by master doc + per-PR sub-docs.
- **`mak:roadmap-planning`** — record which phase this pack belongs to in the roadmap; the roadmap is the SSOT for pack progress/completion status.
- **`mak:brainstorming`** — if direction is vague before pack entry, diverge first, then enter this skill.
- **`mak:dev-kickoff`** — when each step (08's PR units) enters actual implementation, call dev-kickoff.
- **`mak:verify-checklist`** — use for verification after implementing each step.

---

## References

- Templates: `${CLAUDE_PLUGIN_ROOT}/skills/major-feature-pack/assets/00-index.template.md` – `08-implementation-plan.template.md`
- Resulting packs are kept per project in their own directories (e.g. `<docs-root>/<root>/mig_<topic>/` or `feat_<topic>/`).
- SKILL.md does not point at example packs directly — projects manage their pack lists in their own README / INDEX.
