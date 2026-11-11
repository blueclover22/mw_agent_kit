## Security Audit Report

> Audit target: `{{project or module path}}`
> Commit: `{{HEAD short hash, or "uncommitted working tree"}}`
> Audit date: {{YYYY-MM-DD}}
> Detected stack: {{languages / frameworks / package managers / IaC / LLM SDKs}}
> Modules activated: {{Core A01–A10, Secrets, + Dependencies / IaC·Containers / API Top 10:2023 / LLM Top 10:2025 as detected}}

---

### Summary

{{1–3 sentences: overall posture, count of findings per severity, and the most urgent item}}

| Critical | High | Medium | Low | Info |
| :-- | :-- | :-- | :-- | :-- |
| {{n}} | {{n}} | {{n}} | {{n}} | {{n}} |

---

### Scanner Results

<!-- One row per scanner in the checklist's Scanner map that applies to the detected stack -->

| Tool | Command | Result | Notes |
| :--- | :--- | :--- | :--- |
| {{tool}} | `{{read-only command}}` | {{✅ ran / ⏭ not installed / ⚠️ skipped — needs approval}} | {{hit count or reason}} |

---

### Coverage

<!-- Every checklist item in the active set. Inactive modules: one row with "Not checked — module not active" -->
<!-- "No finding" = examined, nothing found. "Not checked" = not examined; say why -->

| ID | Item | Status | Notes |
| :--- | :--- | :--- | :--- |
| {{A01}} | {{Broken Access Control}} | {{Finding / No finding / Not checked}} | {{finding ref or reason}} |

---

### Findings

<!-- Group by severity. Mask secret values: first 4 characters + "…". If a group is empty: "None" -->

#### Critical

- **[`{{file}}:{{line}}`]** {{problem description}}
  - Checklist: {{ID}} · Confidence: {{Confirmed / Suspected — what would confirm it}}
  - Evidence: {{code excerpt or scanner hit, secrets masked}}
  - Recommended fix: {{fix direction}}

#### High

#### Medium

#### Low

#### Info

---

### Limitations

- This is a static, LLM-assisted review of the repository. It is not a substitute for SAST/DAST tooling or a penetration test
- {{items or modules not checked and why, scanners not run, areas excluded from scope}}

---

### Next Steps

- Fixes: {{findings to route to `mak:dev-kickoff`, or Trivial/Small single fixes per the task-grade rules}}
- Long-term: {{items for `mak:roadmap-planning`, e.g. adopting a SAST/DAST pipeline}}
