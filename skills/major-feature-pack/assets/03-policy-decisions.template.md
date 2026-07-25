# 03. Policy Decisions

This document lists the {{N}} policies (D1–D{{N}}) that must be finalized before code changes, along with their rationale and scope of impact.
All decisions default to aligning with the **origin process (02-target-process-reference)**,
while some items (D{{N}} / D{{M}} / ...) carry intentional deviations to fit the current project environment.

> Notation
>
> - **Decided**: finalized after ops / external review
> - **Recommended (tentative)**: this design proceeds assuming adoption
> - **TBD**: requires external confirmation (ops / security / external team / licensing, etc.)

---

## D1. {{decision title}}

### Question

{{What needs to be decided?}}

### Decision — **{{recommended option}}**

{{Decision content. If there are options, a comparison table:}}

| Option                        | Description     | Pros     | Cons     |
| :---------------------------- | :------- | :------- | :------- |
| **A. {{option name}}** (recommended) | {{description}} | {{pros}} | {{cons}} |
| B. {{option name}}            | {{description}} | {{pros}} | {{cons}} |
| C. {{option name}}            | {{description}} | {{pros}} | {{cons}} |

### Rationale

- {{rationale 1}}
- {{rationale 2}}

### Impact

- §04 {{module / model}}
- §05 {{backend impact}}
- §06 {{interface contract — command / event / type impact}}
- §07 {{frontend impact}}

### TBD (optional)

- [ ] {{item requiring external / ops review}}
- [ ] {{assumption that needs confirmation}}

---

## D2. {{decision title}}

(repeat the same structure as D1 — typically 5–9 decisions)

---

## DN. {{decision title}}

---

## Policy → change mapping summary

| Policy | Decision                                      | Affected modules                                                        |
| :----- | :-------------------------------------------- | :--------------------------------------------------------------------- |
| D1     | {{one-line decision}}                         | {{affected modules, one line}}                                          |
| D2     | {{one-line decision}}                         | {{affected modules, one line}}                                          |
| ...    | ...                                           | ...                                                                    |
| DN     | {{one-line decision}}                         | {{affected modules, one line}}                                          |

---

## Ops review checklist

After confirmation with ops / external teams, fill in the items below and update this document to **Decided** status.

- [ ] D1 {{decision essence}} — {{item to confirm}}
- [ ] D2 {{decision essence}} — {{item to confirm}}
- [ ] DN {{decision essence}} — {{item to confirm}}
- [ ] {{other external reviews — license / security certification / ops policy, etc.}}
