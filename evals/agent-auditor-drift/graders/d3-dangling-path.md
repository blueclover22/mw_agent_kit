---
type: llm
focus: last_message
---

The design doc cites `src/export/csvWriter.js` (Target meta and §4 Scope of Changes), but that file does not exist — the real file is `src/export/csv.js`.
PASS if the reply reports `src/export/csvWriter.js` as a dangling / nonexistent path reference, with evidence such as the actual file being `src/export/csv.js` or a failed lookup.
FAIL if the reply does not flag the csvWriter.js path, or treats it as valid.
