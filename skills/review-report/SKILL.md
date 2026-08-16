---
name: review-report
description: Use when reviewing implementation results and writing the review report — code review, design-conformance checks, and stage-completion checks. This skill is the single source of truth for the review procedure and report format used by the mak:reviewer agent.
---

# Review Report Guide

After reviewing implementation results, write the report following this guide.
Report template: `${CLAUDE_PLUGIN_ROOT}/skills/review-report/assets/review-report.template.md` (in English; render the report in the user's language, keeping the structure).

---

## When to Use

- When an implementation stage (mak:coder or direct) is complete and results need review
- When checking that the implementation matches the design doc
- When a combined quality judgement including build/type-check/test results is needed

## Review Procedure

1. **Read the design doc** — find the relevant design doc (per the `mak:design-doc-template` save-path rule, default `.claude/mak/plan/`) and note its §Scope of Changes and §Verification Plan
2. **Read convention docs** — the project's convention documents (e.g. `docs/*.md`, README) and the relevant sections of `CLAUDE.md`
3. **Compare the implementation** — read the files in the design doc's scope and confirm they match the design intent
4. **Check build/type-check results** — prefer the verification results reported via `mak:verify-checklist`; if absent or doubtful, run the project's build/type-check commands directly and attach results
5. **Check coding principles** — look for violations of the kit's coding principles (Simplicity / Precise Changes — the Warning checklist below). If the project defines its own Coding Rules, check those as well
6. **Write the report** — classify issues by severity and output

## Issue Classification

| Grade | Criteria | Action |
| :--- | :--- | :--- |
| 🔴 Critical | Build failure, type error, test failure, security vulnerability, implementation that contradicts the approved design's behavior or breaks a data contract | Must fix, then re-review |
| 🟡 Warning | Code-quality issues, naming inconsistency, unnecessary changes, incomplete features | Fix recommended; prioritize and decide |
| 🟢 Pass | Implemented as designed; verification passed | Nothing notable |
| 📝 Note | Potential issues found outside scope; future improvement ideas | Do not fix; record as separate issues |

The dividing line is **whether what exists is wrong**, not whether it is out of scope. Work that is merely unfinished or unrequested is 🟡, however far it sits from the design; a wrong behavior or a broken contract is 🔴 even inside the design's scope.

### Warning Checklist

Classify the following as 🟡 Warning when found:

- Unrequested features / excessive abstraction / speculative flexibility or configuration (Simplicity)
- Error handling or validation for impossible scenarios (Simplicity)
- Unrequested "improvement" of adjacent code/comments/formatting (Precise Changes)
- Unrequested refactoring of working code (Precise Changes)
- Changed lines not directly connected to the user's request (Precise Changes)
- Uncleaned unused imports/variables/functions introduced by the change (Precise Changes)

Pre-existing unused code (out of scope) goes to 📝 Note and is not fixed.

## Report Format

`${CLAUDE_PLUGIN_ROOT}/skills/review-report/assets/review-report.template.md` is the single source of truth for the report format. Fill in each section of the template as-is. State at the top of the output: "This report follows the `mak:review-report` skill format."

## Cautions

- The reviewer reports only and never modifies code directly
- Record out-of-scope findings only under 📝 Note; do not unilaterally decide to expand scope. If Critical or Warning issues exist, report to the main thread that re-delegation to `mak:coder` is needed — do not re-delegate directly
- If build/test results could not be verified directly, state "could not run directly — based on coder's report"
- Distinguish "no issues" from "could not verify"
- After a slice/stage completion review, hand off to `mak:doc-audit` to check whether other documents referencing this change still hold

If there are no issues, close concisely with "✅ All checks passed".

## References

- Template: `${CLAUDE_PLUGIN_ROOT}/skills/review-report/assets/review-report.template.md`
