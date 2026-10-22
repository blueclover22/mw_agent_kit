#!/usr/bin/env bash
# Seed a small todo CLI whose completed export slice has exactly four planted doc inconsistencies (D1-D4).
set -euo pipefail
mkdir -p .claude/mak/plan docs src/export
cat > src/export/csv.js <<'EOF'
function toCsvRow(fields) {
  return fields.map((f) => String(f)).join(',');
}

module.exports = { toCsvRow };
EOF
cat > src/cli.js <<'EOF'
const { toCsvRow } = require('./export/csv');

function run(args, todos) {
  if (args[0] === 'export') {
    return todos.map((t) => toCsvRow([t.id, t.title, t.done])).join('\n');
  }
  return todos.map((t) => `${t.id}. ${t.title}`).join('\n');
}

module.exports = { run };
EOF
cat > docs/roadmap.md <<'EOF'
# 로드맵

| Phase | 내용 | 상태 | 설계 문서 |
| :--- | :--- | :--- | :--- |
| Phase 1 | 할 일 CRUD (`src/cli.js`) | ✅ 완료 | — |
| Phase 2 | 태그 기능 | ✅ 완료 | — |
| Phase 3 | CSV 내보내기 (`export` 명령) | ✅ 완료 | `.claude/mak/plan/phase2-export.md` |
| Phase 4 | 원격 동기화 | ⬜ 예정 | — |
EOF
cat > docs/architecture.md <<'EOF'
# 아키텍처

## 모듈

- `src/cli.js` — 명령 진입점. 인자의 첫 단어로 명령을 고른다.
- `src/export/` — CSV 내보내기. `formatRow()` 로 할 일 하나를 CSV 한 행으로 변환하고, `src/cli.js` 의 `export` 명령이 이를 호출한다.

## 데이터

할 일은 `{ id, title, done }` 객체 배열로 메모리에 둔다.
EOF
cat > .claude/mak/plan/phase2-export.md <<'EOF'
# Phase 2 — CSV 내보내기

> Target: `src/cli.js`, `src/export/csvWriter.js`
> Related rules: `docs/roadmap.md`, `docs/architecture.md`
> Date: 2026-10-01
> Status: done

---

## 1. Purpose / Non-goals

### Purpose

- 로드맵 Phase 2 항목인 CSV 내보내기를 구현한다 — `export` 명령으로 할 일 목록을 CSV 로 출력

### Non-goals

- 파일 저장, 원격 동기화 (Phase 4)

---

## 2. Current State Analysis

- `src/cli.js` 는 목록 출력만 지원한다

---

## 3. Design Direction

- 한 행 변환 함수 `toCsvRow(fields)` 를 export 모듈에 두고, `src/cli.js` 의 `export` 명령이 각 할 일에 적용한다

---

## 4. Scope of Changes

| # | File | Change type | Content |
| :-- | :--- | :--- | :--- |
| 1 | `src/export/csvWriter.js` | create | `toCsvRow(fields)` |
| 2 | `src/cli.js` | modify | `export` 명령 추가 |

---

## 5. Verification Plan

### 5.0 Success Criteria / Step → verify

| # | Step | verify (success criterion) | Status |
| :-- | :--- | :--- | :--- |
| 1 | `toCsvRow` 구현 | `toCsvRow([1, 'a', false])` → `1,a,false` | ✅ done |
| 2 | `export` 명령 연결 | `run(['export'], todos)` 가 할 일마다 한 행 출력 | ✅ done |
| 3 | 쉼표·따옴표 이스케이프 | `toCsvRow(['a,b'])` → `"a,b"` | ⬜ todo |
EOF
