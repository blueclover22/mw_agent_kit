# mak — MW Agent Kit

> Claude Code 용 개발 프로세스 플러그인 — 발산 → 착수 → 설계 → 구현 → 검증 → 리뷰 → 커밋 흐름을 skill 과 agent 로 제공합니다.
>
> English version: [README.en.md](README.en.md)

`mak` 은 어떤 언어·스택의 프로젝트에서도 동일한 개발 프로세스를 재현하기 위한 Claude Code 플러그인입니다. skill 12종과 agent 6종을 제공하며, 특정 프레임워크나 빌드 도구에 종속되지 않습니다.

---

## 1. 설치

**터미널에서 실행 시:**

```bash
# 1. 마켓플레이스 등록 (최초 1회)
claude plugin marketplace add blueclover22/mw_agent_kit
#    (로컬 체크아웃에서 쓰려면: claude plugin marketplace add /path/to/mw_agent_kit)

# 2. 플러그인 설치
claude plugin install mak@mw-agent-kit
```

**Claude Code 세션에서 실행 시** (빌트인 명령 — 모델 미개입·토큰 무소모):

```
/plugin marketplace add blueclover22/mw_agent_kit
/plugin install mak@mw-agent-kit
```

> 세션 안에서 `claude plugin ...` 을 자연어처럼 입력하면 모델이 대신 실행해 토큰을 소모합니다 — 세션에서는 반드시 `/plugin` 빌트인을 사용하세요.

설치 후 **Claude Code 세션 안에서** 공통 규칙을 1회 설치합니다:

```
/mak:setup
```

`~/.claude/CLAUDE.md` 에 Workflow 작업 등급·코딩 원칙 매핑·mak 위임 규칙이 마커 블록(`<!-- mak:begin -->` … `<!-- mak:end -->`)으로 추가됩니다. 규칙은 **대화 언어에 맞춰 한국어/영어 버전이 자동 선택**되며(`/mak:setup ko` 또는 `/mak:setup en` 으로 지정 가능), 재실행하면 블록만 갱신되고 마커 밖의 기존 내용(개인 규칙 등)은 건드리지 않습니다. 이 블록에는 mak 흐름에서의 **subagent 자율 위임을 사전 요청**하는 문장이 포함됩니다 — 원치 않으면 `/mak:teardown` 으로 블록 전체를 제거하세요(그 문장만 빼는 수단은 없습니다).

## 2. 업데이트

**터미널에서 실행 시:**

```bash
claude plugin update mak@mw-agent-kit
```

**Claude Code 세션에서 실행 시:** `/plugin` 패널 → Installed 탭에서 업데이트

규칙(스니펫)이 변경된 업데이트라면 `/mak:setup` 을 재실행해 블록을 갱신하세요.

> 로컬 경로 마켓플레이스는 버전 번호가 같으면 캐시가 갱신되지 않습니다 — 개발 중에는 재설치(uninstall → install)를 사용하세요.

## 3. 삭제

삭제 전 **반드시** 규칙 블록을 먼저 제거하세요 (플러그인에는 uninstall 훅이 없습니다). Claude Code 세션 안에서:

```
/mak:teardown
```

이후 플러그인을 제거합니다.

**터미널에서 실행 시:**

```bash
claude plugin uninstall mak@mw-agent-kit
```

**Claude Code 세션에서 실행 시:**

```
/plugin uninstall mak@mw-agent-kit
```

## 4. 구성

### Skills (12종)

| skill | 역할 |
| :--- | :--- |
| `/mak:brainstorming` | 요구사항이 막연할 때 아이디어 발산 (구현 금지 게이트) |
| `/mak:dev-kickoff` | Non-trivial 작업 착수 — 요구사항 수렴·옵션 제안·승인 게이트 |
| `/mak:dev-resume` | 다음 작업 자체가 미정일 때 문서에서 근거와 함께 도출하는 재진입점 (읽기·보고 전용) |
| `/mak:design-doc-template` | 설계 문서 규격·저장 경로 규칙(SSOT)·스켈레톤 |
| `/mak:roadmap-planning` | 프로젝트 전체 Phase 구조·상태 추적 (상위 축) |
| `/mak:verify-checklist` | 구현 후 빌드→린트→테스트→포맷→수동 검증 순서 |
| `/mak:review-report` | 리뷰 절차·보고서 형식 (Critical/Warning/Pass/메모) |
| `/mak:doc-audit` | 문서 ↔ 문서 정합성 감사 + 문서가 인용한 코드 경로·심볼의 실재성 대조 |
| `/mak:commit` | 작업 마무리 커밋 — 게이트 통과 후 커밋, 변경 내용 한눈 보고. push 등 기타 git 명령은 명시 요청 시에만 |
| `/mak:setup` | 공통 규칙(Workflow 등급·코딩 원칙 매핑·위임 규칙)을 `~/.claude/CLAUDE.md` 에 마커 블록으로 설치 |
| `/mak:teardown` | 설치된 마커 블록 제거 (플러그인 삭제 전 실행) |
| `/mak:reverse-engineering` | 문서 세트(기본 compact 8종 / standard 14종)를 복사하고 프로젝트를 리버스 엔지니어링 |

### Agents (6종)

| agent | 모델 | 역할 |
| :--- | :--- | :--- |
| `mak:planner` | opus | 비대화 아키텍처 자문(Architecture Brief) 전담, 읽기 전용 |
| `mak:coder` | sonnet | 승인된 설계 기반 구현 전담 |
| `mak:reviewer` | opus | 구현 결과 검토·보고 전담 (코드 수정 금지) |
| `mak:doc-editor` | haiku | 기존 Markdown 문서 편집·동기화 전담 |
| `mak:analyzer` | opus | 코드 분석·문서 채움 전담, 사실만 기록 (코드 수정 금지) |
| `mak:auditor` | opus | `mak:doc-audit` 문서 간 정합성 감사 전담, 보고만 (문서 수정 금지) |

## 5. 사용 방법 및 문서

기본 개발 흐름:

```
[상위 축] /mak:roadmap-planning ── Phase 구조를 먼저 잡고, 각 Phase 착수 시 아래 주기로
[재개]    /mak:dev-resume ─────── 다음 작업 자체가 미정일 때 (세션 재개·인계)
   │ 작업 확정
   ▼
[선택] ① /mak:brainstorming ───── 막연하거나 방향이 여러 갈래일 때만
   │ 방향 선택
   ▼
   ② /mak:dev-kickoff ─────────▶ [위임·선택] mak:planner — Architecture Brief, 읽기 전용
   │ ⚑ 승인 게이트 1 — 설계 내용 승인. 승인 전에는 어떤 파일도 쓰지 않음
   ▼
   ③ /mak:design-doc-template ── 설계 문서 = 단계 간 상태 저장소
   │ ⚑ 승인 게이트 2 — 구현 착수    §5.0 Step 표에 진행 상태(⬜ / ▶ / ✅) 기록
   ▼
   ④ 구현 → /mak:verify-checklist ──▶ [위임] mak:coder
   ▲        빌드→린트→테스트→포맷→수동      Step 통과 시 §5.0 Status 갱신
   │            │
   │            ▼
   │        ⑤ /mak:review-report ──────▶ [위임] mak:reviewer — 보고만, 코드 수정 금지
   └────────────┤ 수정 필요 → 메인이 ④ 로 재위임
                ┊ 자동으로 이어지지 않음 — 사용자가 명시 요청할 때만
                ▼
                ⑥ /mak:commit ── 게이트 통과 후 커밋
                   push 등 기타 git 명령은 각각 별도 명시 요청 시에만

[주기 밖] /mak:doc-audit ─▶ [위임] mak:auditor — 보고만, 문서 수정 금지
          슬라이스·phase 완료 직후 / phase 전환 / 미완료 세션 인계 전
```

- 기호: `▼ │` 기본 진행 · `▶` agent 위임 · `┊` 자동으로 이어지지 않는 사용자 게이트 · `⚑` 승인 게이트 · `▲ └─` 재작업 루프
- 화살표는 자동 실행 경로가 아니라 **메인 스레드가 참고하는 라우팅 힌트**입니다. skill·agent 끼리 서로를 직접 호출하지 않으며, 단계 전환은 항상 메인 스레드가 판단합니다 ([자세히](docs/guide.md#화살표의-의미--실행-보장이-아니라-라우팅-힌트))
- 단계 사이에 남는 상태는 대화 맥락이 아니라 **③ 설계 문서**입니다 — 세션이 끊기면 문서에 적힌 것만 살아남습니다

- 슬래시 메뉴에서 skill 이 `mak:` prefix 없이 보일 수 있습니다(Claude Code 구버전 표시 방식). 표시와 무관하게 `/mak:brainstorming` 정식 형태와 `/brainstorming` 단축 형태 모두 동작하며, 같은 이름의 다른 skill 이 생기면 prefix 형태만 유효합니다.
- 명백한 Trivial / Small 작업(오타·1줄 수정 등)은 위 절차 없이 바로 수정합니다.
- 설계 문서는 기본적으로 프로젝트의 `.claude/mak/plan/` 하위에 저장됩니다.
- 세션을 이어받거나 다음에 할 작업 자체가 미정이면 `/mak:dev-resume` 으로 시작합니다 — 문서에서 진행 상황·문제점·다음 후보를 뽑아 줍니다.
- 기존 프로젝트를 분석해 문서화하려면 `/mak:reverse-engineering` 을 사용합니다.

상세 프로세스·작업 등급·판단 기준·agent 위임 원칙은 **사용 가이드**가 단일 진입점입니다:

| 문서 | 위치 |
| :--- | :--- |
| **사용 가이드** (프로세스 상세) | [docs/guide.md](docs/guide.md) · [docs/guide.en.md](docs/guide.en.md) |
| 플러그인 개발 규칙 (기여자용) | [CLAUDE.md](CLAUDE.md) · [AGENTS.md](AGENTS.md) |

## 6. 커스터마이징

설치된 플러그인 파일은 직접 수정할 수 없습니다. 팀·프로젝트에 맞게 고치려면 저장소를 fork 한 뒤 skill 의 `assets/` 템플릿(설계 문서·리뷰 보고서·로드맵·문서 세트)과 `skills/setup/assets/claude-md-snippet.ko.md`·`.en.md`(주입 규칙, 한/영 미러)를 수정해 자체 마켓플레이스로 배포하세요.

## 7. 라이선스 / 출처

- [MIT License](LICENSE)
- 코딩 원칙 4종(코딩하기 전에 생각하기 / 단순함이 최우선 / 정밀한 수정 / 목표 중심적 실행)은 Andrej Karpathy 가 공유한 AI 코딩 가이드라인에서 영감을 받아 재구성한 것입니다.
