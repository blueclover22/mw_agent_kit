---
type: llm
focus: last_message
---

PASS if the reply flags that getOrder never checks that the user is the order owner or has the admin role (design rule 1), as a Critical or Warning issue.
FAIL if the missing authorization check is not reported.
