# {{Document title}}

> Target: `{{files or modules being changed}}`
> Related rules: `{{path of related rule docs (omit if none)}}`
> Date: {{YYYY-MM-DD}}
> Status: draft (needs approval before implementation)

---

## 1. Purpose / Non-goals

### Purpose

- {{What this change aims to achieve 1}}
- {{What this change aims to achieve 2}}

### Non-goals

- {{What this change explicitly does not cover 1}}
- {{What this change explicitly does not cover 2}}

---

## 2. Current State Analysis

### 2.1 {{Analysis target 1 (e.g. current structure, current behavior)}}

- {{Description of the current state}}
- {{Problem or reason improvement is needed}}

### 2.2 {{Analysis target 2 (add if needed)}}

- {{Description of the current state}}

---

## 3. Design Direction

### 3.1 {{Core principle or design decision 1}}

{{Description. Use the table below when there are options.}}

| Option                               | Description     | Pros     | Cons     |
| :----------------------------------- | :-------------- | :------- | :------- |
| **A. {{Option name}}** (recommended) | {{Description}} | {{Pros}} | {{Cons}} |
| B. {{Option name}}                   | {{Description}} | {{Pros}} | {{Cons}} |

**Recommendation**: **A**. {{1–2 sentence reason for the recommendation}}

### 3.2 {{Core principle or design decision 2 (add if needed)}}

{{Description}}

---

## 4. Scope of Changes

### 4.1 Modified files

| #   | File            | Change type | Content               |
| :-- | :-------------- | :---------- | :-------------------- |
| 1   | `{{file path}}` | modify      | {{summary of change}} |
| 2   | `{{file path}}` | modify      | {{summary of change}} |

### 4.2 New files

| #   | File            | Content                             |
| :-- | :-------------- | :---------------------------------- |
| 1   | `{{file path}}` | {{summary of the file's purpose}}   |

### 4.3 Explicitly not modified

- `{{file path}}` — {{reason it is not modified}}

---

## 5. Verification Plan

### 5.0 Success Criteria / Step → verify

> For multi-step work, use the table. For single-step work, state a one-line success criterion instead.
> `Status` starts as `⬜ todo` for every row and advances only when that row's verify criterion actually passes (`▶ in progress` / `✅ done`). This column is what `mak:dev-resume` reads to see how far work got.

| #   | Step                 | verify (success criterion)          | Status  |
| :-- | :------------------- | :---------------------------------- | :------ |
| 1   | {{step description}} | {{measurable verification method}}  | ⬜ todo |
| 2   | {{step description}} | {{measurable verification method}}  | ⬜ todo |

### 5.1 Automated verification

Run the project's build, type-check, lint, and test commands in order.  
(For the exact commands, follow the verification procedure in the project's CLAUDE.md or README.)

### 5.2 Manual verification (scenarios)

| #   | Scenario                               | Expected result       |
| :-- | :------------------------------------- | :-------------------- |
| V1  | {{verification scenario description}}  | {{expected behavior}} |
| V2  | {{verification scenario description}}  | {{expected behavior}} |

### 5.3 Regression watch points

- {{Existing behavior to watch closely after the change}}

---

## 6. Decisions Needed

### Q1. {{Question requiring a decision}}

| Option                               | Description     | Pros     | Cons     |
| :----------------------------------- | :-------------- | :------- | :------- |
| **A. {{Option name}}** (recommended) | {{Description}} | {{Pros}} | {{Cons}} |
| B. {{Option name}}                   | {{Description}} | {{Pros}} | {{Cons}} |

**Recommendation**: **A**. {{Reason for the recommendation}}

### Q2. {{Question requiring a decision 2 (add if needed)}}

{{Description and options}}

---

## 7. Assumptions / Unverified Areas

- **Assumption**: {{unconfirmed fact}}. Verify during implementation.
- **Unreviewed**: {{item not yet examined}}.
- **Uncertain**: {{part whose outcome is hard to predict}}.

---

## 8. References

- `{{related file path}}` — {{how the file is relevant}}
- `{{related file path}}:{{line number}}` — {{how that line is relevant}}
- {{external doc or commit reference}}
