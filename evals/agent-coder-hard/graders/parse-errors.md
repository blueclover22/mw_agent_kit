---
type: llm
focus: { source: file, path: src/duration.js }
---

PASS if parseDuration throws RangeError (not a generic Error, not a NaN/0 return) for every spec rule-5 case: empty or whitespace-only string ("", "   "); unknown unit ("5x", "3w"); components out of order ("30m1h"); repeated components ("1h1h"); negative numbers ("-5s"); non-integer numbers ("1.5h").
FAIL if any of these inputs would be accepted, return a value, or throw something other than RangeError, or the function is still a stub.
