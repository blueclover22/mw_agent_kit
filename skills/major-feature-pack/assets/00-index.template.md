# {{pack name — e.g. mig_<topic> (migration) or feat_<topic> (new adoption)}} Design Docs

A collection of analysis / policy / design / implementation plans for applying
**{{one-line description of the process / feature from the reference system / external spec — origin behavior for a migration, or external SDK spec / product spec / RFC for a new adoption}}**, documented in `{{primary source document or code location}}`, to the current {{project name}} project.

---

## Target origin / external spec (summary)

> In this skill, "origin" = the existing / source system for a migration, or the external SDK spec / standard / product spec for a new adoption.

{{Summarize the origin process in 5–10 bullets. Include all key components, flows, and external dependencies.}}

1. {{key component 1 — library / module / external system}}
2. {{key component 2}}
3. {{key flow / sequence}}
4. {{external communication / security / data persistence}}
5. {{other — operating environment / known defects, etc.}}

For details, follow these primary sources.

- `{{primary source path}}` (in full)
- {{secondary sources — code / spec / where Known Issues are defined, etc.}}

---

## Key decisions of this design (one-line summary)

> Summarize the D1–DN decisions from §03 as one table row each. Other documents reference this table.

| Item                          | Decision                                                                                   |
| :---------------------------- | :----------------------------------------------------------------------------------------- |
| {{area 1 — e.g. integration approach}} | {{one-line decision — aligned with D1}}                                           |
| {{area 2 — e.g. state management}}     | {{one-line decision — aligned with D2}}                                           |
| {{area 3 — e.g. data model}}           | {{one-line decision — aligned with D3}}                                           |
| {{area N}}                    | {{one-line decision — aligned with DN}}                                                    |

---

## Intentional deviations of this design (vs. origin)

> Aligned with §02 §{{N}} (intentional deviation table). Both documents hold the same table.

| Area             | origin                          | This design                                      | Reason                              |
| :--------------- | :------------------------------ | :----------------------------------------------- | :---------------------------------- |
| {{area name}}    | {{origin behavior}}             | {{this design's behavior}}                       | {{one-line reason for deviation}}   |

---

## Dependencies / prerequisites

This pack builds on top of the following completed work.

- **`{{preceding pack or Phase 1}}`** — {{item this pack depends on}}
- **`{{preceding pack or Phase 2}}`** — {{item this pack depends on}}

Preconditions of this pack itself:

- {{other preconditions — external review / license / security certification, etc.}}

---

## Document structure

| File                                                                       | Role                                                                              |
| :------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- |
| [00-index.md](./00-index.md)                                               | This document. Overall scope / decisions / index                                  |
| [01-current-state-analysis.md](./01-current-state-analysis.md)             | Gap analysis between the current project state and the origin / external spec baseline (P1–PN) |
| [02-target-process-reference.md](./02-target-process-reference.md)         | Origin / external spec summary — restated from this project's perspective         |
| [03-policy-decisions.md](./03-policy-decisions.md)                         | D1–D{{N}} policy decisions                                                        |
| [04-data-model-design.md](./04-data-model-design.md)                       | Data model / storage-location matrix                                              |
| [05-backend-module-design.md](./05-backend-module-design.md)               | Backend module structure / change impact                                          |
| [06-interface-contract-design.md](./06-interface-contract-design.md)       | Interface contract (choose from Tauri IPC / HTTP API / gRPC / FFI / module exports) — commands, events, types, sequences |
| [07-frontend-state-design.md](./07-frontend-state-design.md)               | Frontend state / api / components (where applicable)                              |
| [08-implementation-plan.md](./08-implementation-plan.md)                   | N-step implementation / PR split / verification checklist                         |

> If any document is omitted, mark its table row with "(omitted — reason)".

---

## Scope

What this design covers:

- {{included scope 1}}
- {{included scope 2}}
- {{included scope 3}}

What this design does not cover (separate work):

- {{excluded item 1 — reason}}
- {{excluded item 2 — reason}}
- {{excluded item 3 — reason}}

---

## Workflow

1. Share the origin baseline via `02-target-process-reference.md`
2. Agree on current-code gaps via `01-current-state-analysis.md`
3. Review / finalize the D1–D{{N}} decisions in `03-policy-decisions.md` — especially {{items requiring external / ops review}}
4. Review designs `04` – `07`
5. Implement in PR units per `08-implementation-plan.md`
