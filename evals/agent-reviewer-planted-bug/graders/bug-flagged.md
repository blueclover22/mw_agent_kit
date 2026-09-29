---
type: llm
focus: last_message
---

PASS if the reply flags, as a Critical or Warning issue, that applyDiscount uses `>` instead of `>=` (or otherwise excludes the exact 100000 threshold that docs/design.md says should qualify for the discount).
FAIL if the reply finds no issue with the comparison, or only reports unrelated/style issues.
