# Analyzed Issues — <project-name>

> Template: copy source for the out-of-set issue document written by `mak:reverse-engineering` §5. Fill it in the output language, delete empty categories, and delete this notice when written.

This document collects the code-issue candidates observed while reverse-engineering the documentation set. It is **a separate document outside the set**; set documents never reference it ([`00.INDEX.md`](00.INDEX.md) §Content Rules). Links from this document into set documents (one-way) are allowed.

- Each item is a code observation; whether and when to fix it is not decided here.
- Locations are written as `<location convention — e.g. class·method, file:statement>`.
- **Severity**
  - **High** — security exposure or possible data corruption
  - **Medium** — possible functional malfunction or operational failure
  - **Low** — cleanup or observability
- **Status**
  - **Confirmed** — the code / configuration lines were checked directly
  - **Suspected** — the code flow suggests this behavior, but runtime / DB / environment confirmation is needed (state in parentheses, in the Problem or Notes cell, what must be checked)
- **Secrets** — never quote secret values (passwords, keys, tokens); give the location only.

---

## 1. Security

| # | Severity | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| S-1 | <High> | <Confirmed> | <problem> | <location> | <notes> |

## 2. Concurrency · Data Integrity

| # | Severity | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| D-1 | <High> | <Suspected> | <problem (what must be checked)> | <location> | <notes> |

## 3. Functional Bugs

| # | Severity | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| B-1 | <Medium> | <Confirmed> | <problem> | <location> | <notes> |

## 4. Error Handling · Observability

| # | Severity | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| E-1 | <Medium> | <Confirmed> | <problem> | <location> | <notes> |

## 5. Configuration · Build

| # | Severity | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- | :-- |
| C-1 | <Low> | <Confirmed> | <problem> | <location> | <notes> |

## 6. Unused · Cleanup Candidates

| # | Status | Problem | Location | Notes |
| :-- | :-- | :-- | :-- | :-- |
| U-1 | <Confirmed> | <problem> | <location> | <notes> |
