# 08. Implementation Plan

This document lays out how to split the §03 – §07 decisions/designs into PR units.
Following the **"one PR = one purpose"** principle, keep feature additions and refactoring from mixing.

---

## 0. Overall step overview

| Step | Title                                            | Deliverables                                                            | Regression risk            |
| :--- | :----------------------------------------------- | :--------------------------------------------------------------------- | :------------------------- |
| 1    | {{step title}}                                   | {{changed files / modules, one line}}                                   | {{regression surface}}     |
| 2    | {{step title}}                                   | ...                                                                    | ...                        |
| ...  | ...                                              | ...                                                                    | ...                        |
| N    | {{step title}}                                   | ...                                                                    | ...                        |

At each step, verify **build / type check / lint / relevant tests** before moving to the next step.

---

## Step 1. {{step title}}

**Purpose**: {{problem this step resolves — aligned with P{{N}}}}

### Changes

- `{{file path}}`:
  - {{change item 1}}
  - {{change item 2}}
- `{{file path}}` (new):
  - {{role}}

### Verification

> Write verification commands for the project's build system. Below are the items — commands follow the project convention.

- Compile / type check: `{{cargo check / tsc --noEmit / mvn compile / go build / etc.}}`
- Lint: `{{cargo clippy / eslint / detekt / golangci-lint / pylint / etc.}}`
- Unit / integration tests:
  - {{test item 1 — function level}}
  - {{test item 2 — module integration}}
  - {{test item 3 — mocked external dependencies}}
- Manual (TC-{{N}}): {{manual verification scenario}}

### Regression guards

- {{impact surface of existing code — patterns to check via grep}}
- {{call sites requiring bulk updates when signatures change}}

---

## Step 2. {{step title}}

(repeat — typically 5–10 steps)

---

## Step N. {{step title}}

---

## PR split proposal

| PR  | Steps included | Title                                                                  | Reason                                             |
| :-- | :-------- | :-------------------------------------------------------------------------- | :------------------------------------------------- |
| 1   | 1         | `{{prefix}}: {{one-line PR title — feat / refactor / fix / etc.}}`          | {{why a standalone PR — near-zero regression, etc.}} |
| 2   | 2         | `...`                                                                       | ...                                                 |
| ... | ...       | ...                                                                         | ...                                                 |
| N   | N+M       | `{{interface contract change (IPC / HTTP API, etc.) + caller-side alignment}}` | {{bundled in the same PR to avoid type-break}}    |

---

## Verification checklist (common to all PRs)

### Automated (common to Steps 1–N)

> Fill in commands for the project's build system. Below are the items / intent.

| Item                              | Command                             |
| :-------------------------------- | :---------------------------------- |
| Compile / type check              | `{{...}}`                            |
| Lint / static analysis            | `{{...}}`                            |
| Format (check)                    | `{{...}}`                            |
| Unit / integration tests          | `{{...}}`                            |
| Build (release artifacts)         | `{{...}}`                            |
| Dependency / security scan (if applicable) | `{{...}}`                    |

### Security / static verification (if applicable)

- [ ] {{0-hit sensitive-data grep verification — state regex / patterns}}
- [ ] {{type exhaustiveness verification — missing match / switch arms caught at compile time}}
- [ ] {{config file migration verification — boots normally in existing environments}}
- [ ] {{external dependency license / vulnerability scan}}

### Manual test cases

Run the TCs below directly to verify. Mark `[x]` after each case is complete.

#### TC-01. {{scenario title}}

**Preconditions**: {{initial state}}

**Steps**:

1. {{step 1}}
2. {{step 2}}

**Expected results**:

- {{expectation 1}}
- {{expectation 2}}

**Result**: [ ] Pass / [ ] Fail

#### TC-02. {{scenario title}}

(repeat — typically 5–15 TCs)

---

## Risks / mitigations

| Risk                                                                          | Mitigation                                                                                 |
| :---------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------- |
| {{technical risk — external SDK not issued / compatibility / security certification, etc.}} | {{response — isolate with mocks / option branching / separate PR split}}      |
| {{operational risk — migration side effects / insufficient operator training, etc.}} | {{response — staged split / user guidance / rollback procedure}}                    |
| {{security risk — sensitive data leakage / permission bypass, etc.}}          | {{response — enforced resource cleanup / static grep / enforced guards}}                   |
| {{this pack cannot be entered if a preceding pack / Phase is incomplete}}     | {{state prerequisite dependencies + precondition check before entry}}                       |
