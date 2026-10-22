#!/usr/bin/env bash
# Seed a small Node server with a stale README port, a minimal doc-set rulebook, and a build-ops doc whose four cells are TODO.
set -euo pipefail
mkdir -p src docs
cat > package.json <<'EOF'
{
  "name": "memo-server",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start": "node src/server.js"
  },
  "dependencies": {
    "better-sqlite3": "^11.0.0"
  }
}
EOF
cat > src/db.js <<'EOF'
const Database = require('better-sqlite3');

const db = new Database('data/app.db');
db.exec('CREATE TABLE IF NOT EXISTS memos (id INTEGER PRIMARY KEY, body TEXT NOT NULL)');

function listMemos() {
  return db.prepare('SELECT id, body FROM memos').all();
}

module.exports = { listMemos };
EOF
cat > src/server.js <<'EOF'
const http = require('http');
const { listMemos } = require('./db');

const port = process.env.PORT || 8080;

http
  .createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(listMemos()));
  })
  .listen(port, () => {
    console.log(`listening on ${port}`);
  });
EOF
cat > README.md <<'EOF'
# memo-server

메모 목록을 JSON 으로 돌려주는 작은 서버.

## 실행

```sh
npm install
npm start
```

서버는 http://localhost:3000 에서 뜬다.
EOF
cat > docs/00.INDEX.md <<'EOF'
# 문서 인덱스

| 파일 | 주제 (SSOT) |
| :--- | :--- |
| `06.build-ops.md` | 실행·빌드·배포 |

작성 규칙은 `docs/CLAUDE.md` 를 따른다.
EOF
cat > docs/CLAUDE.md <<'EOF'
# docs 작성 규칙

- 코드에서 직접 확인한 사실만 기록한다. 추측·계획·개선 제안은 쓰지 않는다
- README 등 기존 문서의 서술은 코드로 확인될 때만 옮긴다 — 코드와 다르면 코드를 따른다
- 코드에 근거가 없는 셀은 `_(TODO — <필요한 정보>)_` 로 남긴다
- 표 구조와 행 이름은 바꾸지 않는다
EOF
cat > docs/06.build-ops.md <<'EOF'
# 실행·빌드·배포

| 항목 | 값 |
| :--- | :--- |
| Start command | _(TODO)_ |
| Default port | _(TODO)_ |
| Data store | _(TODO)_ |
| Deploy target | _(TODO)_ |
EOF
