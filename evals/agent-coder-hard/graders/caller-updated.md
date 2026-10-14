---
type: llm
focus: { source: file, path: src/timeout.js }
---

PASS if getTimeout requires parseDuration from "./duration" and returns parseDuration applied to config.timeout, falling back to "30s" when config.timeout is missing or undefined (so getTimeout({}) → 30000 and getTimeout({ timeout: "2m" }) → 120000), and the old `parseInt(config.timeout, 10) * 1000` computation is gone.
FAIL if parseDuration is not used, the "30s" default is missing or a different value, or the parseInt*1000 form remains.
