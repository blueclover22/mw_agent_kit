---
type: llm
focus: last_message
---

PASS if the first reply asks at least two distinct clarifying questions together in one message before any implementation.
FAIL if it asks only one question (deferring others to later turns) or starts implementing without asking.
