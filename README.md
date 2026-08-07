# mak — MW Agent Kit

> Claude Code 용 개발 프로세스 플러그인 — 발산 → 착수 → 설계 → 구현 → 검증 → 리뷰 → 커밋 흐름을 skill 과 agent 로 제공합니다.
>
> English version: [README.en.md](README.en.md)

`mak` 은 어떤 언어·스택의 프로젝트에서도 동일한 개발 프로세스를 재현하기 위한 Claude Code 플러그인입니다. skill 11종과 agent 5종을 제공하며, 특정 프레임워크나 빌드 도구에 종속되지 않습니다.

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

`~/.claude/CLAUDE.md` 에 Workflow 작업 등급·코딩 원칙 매핑·mak 위임 요약이 마커 블록(`<!-- mak:begin -->` … `<!-- mak:end -->`)으로 추가됩니다. 규칙은 **대화 언어에 맞춰 한국어/영어 버전이 자동 선택**되며(`/mak:setup ko` 또는 `/mak:setup en` 으로 지정 가능), 재실행하면 블록만 갱신되고 마커 밖의 기존 내용(개인 규칙 등)은 건드리지 않습니다.

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

### Skills (11종)

| skill | 역할 |
| :--- | :--- |
| `/mak:brainstorming` | 요구사항이 막연할 때 아이디어 발산 (구현 금지 게이트) |
| `/mak:dev-kickoff` | Non-trivial 작업 착수 — 요구사항 수렴·옵션 제안·승인 게이트 |
| `/mak:design-doc-template` | 설계 문서 규격·저장 경로 규칙(SSOT)·스켈레톤 |
| `/mak:roadmap-planning` | 프로젝트 전체 Phase 구조·상태 추적 (상위 축) |
| `/mak:verify-checklist` | 구현 후 빌드→린트→테스트→포맷→수동 검증 순서 |
| `/mak:review-report` | 리뷰 절차·보고서 형식 (Critical/Warning/Pass/메모) |
| `/mak:doc-audit` | 문서 ↔ 문서 정합성 감사 + 문서가 인용한 코드 경로·심볼의 실재성 대조 |
| `/mak:commit` | 작업 마무리 커밋 — 게이트 통과 후 커밋, 변경 내용 한눈 보고. push 등 기타 git 명령은 명시 요청 시에만 |
| `/mak:setup` | 공통 규칙(Workflow 등급·코딩 원칙 매핑·위임 요약)을 `~/.claude/CLAUDE.md` 에 마커 블록으로 설치 |
| `/mak:teardown` | 설치된 마커 블록 제거 (플러그인 삭제 전 실행) |
| `/mak:reverse-engineering` | 문서 세트(기본 compact 8종 / standard 14종)를 복사하고 프로젝트를 리버스 엔지니어링 |

### Agents (5종)

| agent | 모델 | 역할 |
| :--- | :--- | :--- |
| `mak:planner` | opus | 비대화 아키텍처 자문(Architecture Brief)·설계 문서 집필 |
| `mak:coder` | sonnet | 승인된 설계 기반 구현 전담 |
| `mak:reviewer` | opus | 구현 결과 검토·보고 전담 (코드 수정 금지) |
| `mak:doc-editor` | haiku | 기존 Markdown 문서 편집·동기화 전담 |
| `mak:analyzer` | opus | 코드 분석·문서 채움·문서 감사 전담, 감사는 보고만 (코드 수정 금지) |

## 5. 사용 방법 및 문서

기본 개발 흐름:

```
(막연하면) /mak:brainstorming → /mak:dev-kickoff → [필요 시 mak:planner 자문]
   → 설계 문서 (mak:design-doc-template)
   → 사용자 승인 → 구현 (mak:coder) → /mak:verify-checklist → mak:reviewer 리뷰
   → (마무리) /mak:commit — push 등 기타 git 명령은 명시 요청 시에만
```

- 슬래시 메뉴에서 skill 이 `mak:` prefix 없이 보일 수 있습니다(Claude Code 구버전 표시 방식). 표시와 무관하게 `/mak:brainstorming` 정식 형태와 `/brainstorming` 단축 형태 모두 동작하며, 같은 이름의 다른 skill 이 생기면 prefix 형태만 유효합니다.
- 명백한 Trivial / Small 작업(오타·1줄 수정 등)은 위 절차 없이 바로 수정합니다.
- 설계 문서는 기본적으로 프로젝트의 `.claude/mak/plan/` 하위에 저장됩니다.
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
