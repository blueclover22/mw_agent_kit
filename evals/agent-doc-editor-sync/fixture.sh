#!/usr/bin/env bash
# Seed a Korean README with a new configuration section (whose code example disagrees with the source) and an English twin lacking it.
set -euo pipefail
mkdir -p src
cat > src/client.js <<'EOF'
function createClient(baseUrl, { retries = 3, timeoutMs = 5000 } = {}) {
  return {
    baseUrl,
    retries,
    timeoutMs,
    get(path) {
      return { url: baseUrl + path, retries, timeoutMs };
    },
  };
}

module.exports = { createClient };
EOF
cat > README.md <<'EOF'
# acme-client

## 개요

재시도와 타임아웃을 지원하는 작은 HTTP 클라이언트.

## 설치

```sh
npm install acme-client
```

## 설정

`createClient` 의 두 번째 인자로 다음 옵션을 넘길 수 있다.

| 옵션 | 타입 | 기본값 | 설명 |
| :--- | :--- | :--- | :--- |
| `retries` | number | `3` | 실패 시 재시도 횟수 |
| `timeoutMs` | number | `5000` | 요청 타임아웃(ms) |

```js
const client = createClient('https://api.example.com', 5);
```

## 라이선스

MIT
EOF
cat > README.en.md <<'EOF'
# acme-client

## Overview

A tiny HTTP client with retries and timeouts.

## Installation

```sh
npm install acme-client
```

## License

MIT — see LICENSE for details.
EOF
