---
type: llm
focus: { source: file, path: README.en.md }
---

PASS if README.en.md now has a Configuration section (an English heading such as "## Configuration" or "## Options") at the same `##` level as the other sections, placed after "## Installation" and before "## License", containing a Markdown table whose four columns are the English equivalents of 옵션 / 타입 / 기본값 / 설명 (e.g. Option / Type / Default / Description) and both rows: retries (number, default 3) and timeoutMs (number, default 5000), with English descriptions.
FAIL if the section is missing, uses a different heading level, is placed elsewhere, the table is missing a column or a row, the defaults differ from 3 and 5000, or the content is left in Korean.
