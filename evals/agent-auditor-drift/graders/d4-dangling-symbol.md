---
type: llm
focus: last_message
---

docs/architecture.md says the export module converts a row with `formatRow()`, but no such symbol exists — the real function in `src/export/csv.js` is `toCsvRow`.
PASS if the reply reports `formatRow()` as a dangling / nonexistent symbol reference in docs/architecture.md, with evidence such as the actual symbol being `toCsvRow` or a grep finding no definition.
FAIL if the reply does not flag `formatRow`, or treats it as valid.
