---
type: llm
focus: { source: file, path: src/strings.js }
---

PASS if slugify implements all five rules of the spec — trim, lowercase, replace every non-alphanumeric run with a hyphen, collapse repeated hyphens, strip leading/trailing hyphens — such that "  Hello, World!  " yields "hello-world".
FAIL if any rule is missing or the function is still a stub.
