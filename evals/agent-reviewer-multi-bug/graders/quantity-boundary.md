---
type: llm
focus: last_message
---

PASS if the reply flags that validateQuantity rejects a quantity of exactly 100 (`qty >= 100`) although design rule 2 allows 100.
FAIL if this boundary mismatch is not reported.
