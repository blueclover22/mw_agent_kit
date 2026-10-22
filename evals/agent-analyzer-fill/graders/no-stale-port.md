---
type: llm
focus: { source: file, path: docs/06.build-ops.md }
---

The code (src/server.js) listens on `process.env.PORT || 8080`; README.md's "localhost:3000" is stale.
PASS if docs/06.build-ops.md records the default port as 8080 (optionally noting the PORT environment-variable override) and does not present 3000 as the port. Mentioning 3000 only to say README.md is stale or disagrees with the code is acceptable.
FAIL if 3000 is recorded as the default port or as an equally valid alternative, or the Default port row is still `_(TODO)_`.
