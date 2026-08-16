## Review Report

> Review target: `{{design doc path or summary of scope of changes}}`
> Review date: {{YYYY-MM-DD}}
> Reviewer: reviewer

---

### Summary

{{Summarize the whole review in 1–3 sentences. State whether it passes or needs fixes}}

---

### Build / Verification Results

| Stage              | Result                                          | Notes                       |
| :----------------- | :---------------------------------------------- | :-------------------------- |
| Build / type check | {{✅ Pass / ❌ Fail / ⏭ Not run}}               | {{error message or omit}}   |
| Lint               | {{✅ Pass / ❌ Fail / ⏭ Not run}}               |                             |
| Unit tests         | {{✅ Pass / ❌ Fail / ⏭ Not run}}               |                             |
| Format             | {{✅ Pass / ⏭ Skipped}}                         |                             |
| Manual scenarios   | {{✅ Confirmed / ⚠️ Could not verify / ⏭ N/A}}  |                             |

---

### Issue List

#### 🔴 Critical

<!-- Build failure, type error, test failure, security vulnerability, implementation that contradicts the approved design's behavior or breaks a data contract -->
<!-- Merely unfinished or unrequested work is Warning, not Critical -->
<!-- If none: "None" -->

- **[`{{file name}}:{{line}}`]** {{problem description}}
  - Cause: {{cause}}
  - Recommended fix: {{fix direction}}

#### 🟡 Warning

<!-- Code-quality issues, naming inconsistency, unnecessary changes, incomplete features -->
<!-- Simplicity violations / Precise Changes violations also go here -->
<!-- If none: "None" -->

- **[`{{file name}}:{{line}}`]** {{problem description}}
  - Category: {{Simplicity / Precise Changes / other quality}}
  - Recommended fix: {{fix direction}}

#### 🟢 Pass

<!-- Items implemented as designed -->

- {{description of passing item}}

#### 📝 Note (out-of-scope findings)

<!-- Not fixed in this scope. Record only future improvement ideas or potential issues -->
<!-- Section may be omitted if none -->

- **[`{{file name}}`]** {{finding}} — not fixed in this scope. Recommend tracking as a separate issue.

---

### Conclusion

{{If no issues}}:

`✅ All checks passed — ready to proceed to the next stage`

{{If fixes are needed}}:

`⚠️ {{N}} fixes needed — re-delegation to coder recommended`

Items requiring fixes:

1. {{summary of Critical/Warning issue}}
2. {{summary of Critical/Warning issue}}
