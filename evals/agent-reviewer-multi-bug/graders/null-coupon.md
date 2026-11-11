---
type: llm
focus: last_message
---

PASS if the reply flags that total reads `coupon.rate` without handling a null/absent coupon, which design rule 4 says must mean a 0 discount.
FAIL if the null-coupon crash is not reported.
