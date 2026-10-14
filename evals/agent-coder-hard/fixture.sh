#!/usr/bin/env bash
# Seed stub duration parse/format functions, a caller using the old parseInt form, and the spec describing the exact behavior.
set -euo pipefail
mkdir -p src docs
cat > docs/spec.md <<'EOF'
# duration 사양

`src/duration.js` 의 `parseDuration` / `formatDuration` 과 `src/timeout.js` 의 호출부는 다음 규칙을 따른다.

## 단위

| 단위 | 의미 | 밀리초 |
| :--- | :--- | :--- |
| `d` | 일 | 86400000 |
| `h` | 시간 | 3600000 |
| `m` | 분 | 60000 |
| `s` | 초 | 1000 |
| `ms` | 밀리초 | 1 |

주의: `ms`(밀리초)와 `m`(분)은 다른 단위다. `"500ms"` 는 500 밀리초이지 "500분 + s" 가 아니다 — 파싱할 때 `ms` 를 `m` 보다 먼저 판별해야 한다.

## parseDuration(str)

1. 위 단위를 붙인 성분(`<정수><단위>`)을 하나 이상 이어 쓸 수 있다. 성분은 반드시 큰 단위에서 작은 단위 순(`d` > `h` > `m` > `s` > `ms`)이어야 한다. 예: `"1h30m"`, `"2d4h"`, `"1m500ms"`
2. 성분 사이의 공백을 허용한다(`"1h 30m"`). 문자열 앞뒤 공백은 제거한다.
3. 단위 없이 음이 아닌 정수만 있으면 초 단위로 본다. 예: `"90"` → `90000`
4. 반환값은 정수 밀리초다.
5. 다음 경우에는 `RangeError` 를 던진다:
   - 빈 문자열 또는 공백만 있는 문자열 (`""`, `"   "`)
   - 알 수 없는 단위 (`"5x"`, `"3w"`)
   - 순서가 어긋나거나 반복된 성분 (`"30m1h"`, `"1h1h"`)
   - 음수 또는 정수가 아닌 숫자 (`"-5s"`, `"1.5h"`)

## formatDuration(ms)

6. 큰 단위부터 성분을 이어 붙이고, 값이 0 인 성분은 생략한다. 예: `5400000` → `"1h30m"`, `90061001` → `"1d1h1m1s1ms"`. 단, `0` → `"0s"`
7. 왕복 보장: 음이 아닌 모든 정수 `x` 에 대해 `parseDuration(formatDuration(x)) === x`
8. 음수 또는 정수가 아닌 입력에는 `RangeError` 를 던진다 (`-1`, `1.5`).

## 호출부

9. `src/timeout.js` 의 `getTimeout(config)` 는 `config.timeout` 을 `parseDuration` 으로 해석해 밀리초를 반환한다. `config.timeout` 이 없거나 `undefined` 이면 `"30s"` 를 기본값으로 쓴다.

## 예시

| 호출 | 결과 |
| :--- | :--- |
| `parseDuration("1h30m")` | `5400000` |
| `parseDuration(" 1m 500ms ")` | `60500` |
| `parseDuration("90")` | `90000` |
| `parseDuration("30m1h")` | `RangeError` |
| `formatDuration(60500)` | `"1m500ms"` |
| `formatDuration(0)` | `"0s"` |
| `getTimeout({})` | `30000` |
| `getTimeout({ timeout: "2m" })` | `120000` |
EOF
cat > src/duration.js <<'EOF'
function parseDuration(str) {
  // TODO: implement per docs/spec.md
  return 0;
}

function formatDuration(ms) {
  // TODO: implement per docs/spec.md
  return '';
}

module.exports = { parseDuration, formatDuration };
EOF
cat > src/timeout.js <<'EOF'
function getTimeout(config) {
  return parseInt(config.timeout, 10) * 1000;
}

module.exports = { getTimeout };
EOF
