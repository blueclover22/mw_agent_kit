---
type: llm
focus: { source: file, path: src/duration.js }
---

PASS if formatDuration implements spec rules 6–8: emits components largest-first (d, h, m, s, ms) and omits zero components (5400000 → "1h30m", 90061001 → "1d1h1m1s1ms", 60500 → "1m500ms"); returns "0s" for 0; its output always parses back to the same value with parseDuration (round trip for every non-negative integer, including values with only a ms component such as 1 → "1ms"); and throws RangeError for negative or non-integer input (-1, 1.5).
FAIL if any of these rules is missing or wrong (e.g. zero components printed, 0 → "" or "0ms", no RangeError on bad input), or the function is still a stub.
