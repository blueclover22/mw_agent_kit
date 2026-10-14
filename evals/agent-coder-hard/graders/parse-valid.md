---
type: llm
focus: { source: file, path: src/duration.js }
---

PASS if parseDuration implements spec rules 1–4: accepts units d, h, m, s, ms with `ms` recognized before `m` (so "500ms" is 500, not minutes); combines components in strictly descending order ("1h30m" → 5400000, "2d4h" → 187200000, "1m500ms" → 60500); allows whitespace between components and trims leading/trailing whitespace ("1h 30m" and " 1m 500ms " parse); treats a bare non-negative integer as seconds ("90" → 90000); and returns an integer number of milliseconds.
FAIL if any of these rules is missing or wrong (e.g. "500ms" parsed as minutes, whitespace rejected, "90" not treated as seconds), or the function is still a stub.
