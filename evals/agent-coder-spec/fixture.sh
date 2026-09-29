#!/usr/bin/env bash
# Seed an unimplemented slugify function and the spec describing its exact behavior.
set -euo pipefail
mkdir -p src docs
cat > docs/spec.md <<'EOF'
# slugify 사양

`slugify(input)` 은 다음 규칙으로 문자열을 URL-safe 슬러그로 변환한다:

1. 문자열 앞뒤 공백을 제거한다.
2. 모든 알파벳을 소문자로 변환한다 (`toLowerCase`).
3. 알파벳/숫자가 아닌 문자(공백 포함)는 하이픈(`-`)으로 치환한다.
4. 연속된 하이픈은 하나로 합친다.
5. 문자열 앞뒤에 남은 하이픈은 제거한다.

예: `"  Hello, World!  "` → `"hello-world"`
EOF
cat > src/strings.js <<'EOF'
function slugify(input) {
  // TODO: implement per docs/spec.md
  return '';
}

module.exports = { slugify };
EOF
