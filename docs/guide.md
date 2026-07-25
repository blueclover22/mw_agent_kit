# mak 사용 가이드

> 대상: `mak` 플러그인의 skill 10종 + agent 5종 + `/mak:setup` 이 설치하는 공통 Workflow 규칙
> 목적: 어떤 프로젝트에서도 일관된 "발산 → 착수/아키텍처 자문 → 설계 → 검증 → 리뷰" 흐름 재현, 그리고 프로젝트 전체 방향을 다루는 로드맵 축 지원
>
> English version: [guide.en.md](guide.en.md)

---

## 1. 이 kit 의 목적

**개발 프로세스 skill 세트 (발산 → 착수/아키텍처 자문 → 설계 → 검증 → 리뷰) + 상위 로드맵 축 + 코딩 원칙(§Coding Rules)**

프로젝트마다 반복되는 핵심 단계(아이디어 발산 → 개발 착수·수렴 → 필요 시 아키텍처 자문 → 설계 문서화 → 구현 검증 → 리뷰 보고)를 일관된 절차와 형식으로 수행할 수 있도록 재사용 가능한 skill 을 묶어 제공한다. 여기에 더해, 여러 Phase 에 걸친 중장기 방향을 다루는 `mak:roadmap-planning` 을 별도 축으로 제공한다.

- 특정 언어, 프레임워크, 빌드 도구에 종속되지 않는다
- agent(mak:planner/coder/reviewer/doc-editor/analyzer)가 있으면 각 skill 을 위임 형태로 활용하고, agent 위임이 어려운 환경에서도 skill 만으로 동일한 흐름을 수행할 수 있다
- 코딩 원칙(코딩하기 전에 생각하기 / 단순함이 최우선 / 정밀한 수정 / 목표 중심적 실행)은 본 가이드 §2.2 에 정의되며, 각 skill 절차 안에 자가 점검·게이트로 녹아 있다. 사용자가 전역/프로젝트 CLAUDE.md 에 자체 §Coding Rules 를 두면 그것이 우선한다
- `/mak:setup` 은 Workflow 작업 등급·코딩 원칙 매핑(§2.2 사본)·mak 위임 요약을 `~/.claude/CLAUDE.md` 마커 블록으로 설치한다 (개인 규칙은 건드리지 않음)

## 2. 각 skill 개요

| skill | 한 줄 설명 |
| :--- | :--- |
| `mak:roadmap-planning` | 프로젝트 전체 Phase 구조 수립·유지. 중장기 방향·우선순위·상태 추적 전담. 구현·코드 수정 금지(HARD-GATE) |
| `mak:brainstorming` | 요구사항이 불명확하거나 방향이 여러 갈래일 때 아이디어 발산 전용 단계. 평가 축에 단순성 포함, "더 단순한 대안" 자문 강제. 구현·설계 문서 작성 금지(HARD-GATE) |
| `mak:dev-kickoff` | Non-trivial / Risky 또는 등급 불명확 작업의 착수 분류·대화형 오케스트레이션. 요구사항 수렴 → planner 자문 여부 결정 → 접근법 제안 → 검증 가능한 목표 변환 → 승인 게이트 → 문서화 인계. 설계 승인 전 구현 금지(HARD-GATE) |
| `mak:design-doc-template` | 설계 문서의 §1~§8 섹션 구성, §5.0 Step → verify 표, 옵션 비교 표, 추정 표기, 품질 체크리스트, **저장 경로 규칙 SSOT(기본 `.claude/mak/plan/`)** 제공 |
| `mak:major-feature-pack` | 선행 분석을 여러 문서로 분리해야 추적 가능한 큰 신규 기능·다른 스택 이식을 9개 문서로 정형화. `mig_` / `feat_` prefix, 정합 출처 규약, 의도적 차이 표 포함. 다PR·다모듈 여부가 아니라 분석면 넓이로 판단(§4) |
| `mak:verify-checklist` | 구현 완료 후 빌드→린트→테스트→포맷(변경 파일만)→수동 시나리오 순 검증. 보고 직전 자가 질의 + "사전 정의 성공 기준 vs 결과" 표 |
| `mak:review-report` | 리뷰 절차와 보고서 형식의 SSOT. 🔴 Critical / 🟡 Warning / 🟢 Pass / 📝 메모 분류, Warning 세부 점검 6종 |
| `mak:setup` / `mak:teardown` | 공통 규칙을 `~/.claude/CLAUDE.md` 마커 블록으로 설치 / 제거 |
| `mak:reverse-engineering` | 표준 문서 세트(14종 + domains/)를 프로젝트 `docs/` 로 복사하고 코드 분석으로 채움 |

> 각 skill 상단에 "다음 경우엔 다른 skill 로" 포인터가 있어, 잘못된 skill 을 골라도 절차 중 올바른 skill 로 자가 유도된다.

### 2.1 작업 등급

작업은 먼저 크기와 위험도로 분류한다. 이 분류가 `mak:dev-kickoff` 와 `mak:planner` 사용 여부를 결정한다.

| 등급 | 기준 | 기본 흐름 |
| :--- | :--- | :--- |
| **Trivial** | 오타·포맷·주석·1줄 수정·명백한 단일 파일 독립 수정 | 설계 문서·승인 게이트 없이 기존 파일을 읽고 바로 수정. 필요 시 `mak:coder` 사용 |
| **Small** | 영향 범위가 작고 되돌리기 쉬운 버그 수정·소규모 동작 변경 | 짧은 변경 의도와 검증 방법을 공유한 뒤 진행. 보통 `mak:dev-kickoff` 생략 (버그는 재현·검증 유지) |
| **Non-trivial** | 여러 파일·모듈 영향, 새 기능·컴포넌트, 구조 선택이 필요한 변경 | `mak:dev-kickoff` 로 착수. 기존 구조가 복잡하거나 선택지가 갈리면 `mak:planner` Architecture Brief 요청 |
| **Risky** | 데이터 모델·의존성·보안·배포·마이그레이션·다중 모듈 영향 | `mak:dev-kickoff` + `mak:planner` Architecture Brief 원칙적 사용 |

### 2.2 코딩 원칙 매핑 (kit 코딩 원칙의 SSOT)

| 원칙 | 핵심 행동 | 강제 게이트 |
| :--- | :--- | :--- |
| **코딩하기 전에 생각하기** | 가정 명시("추정") · 다중 해석 모두 제시 · 더 단순한 대안 제안/반박 · 이해 안 되면 멈춤·질문 | mak:brainstorming §3·§5, mak:dev-kickoff §2·§3·§4, mak:planner Brief, mak:design-doc-template §Quality Checklist |
| **단순함이 최우선** | 미요청 기능·추측성 유연성·발생 불가 오류 처리 금지 · 단순한 대안 포함 | mak:dev-kickoff §3·§4·§8, mak:planner Brief, mak:design-doc-template §Quality Checklist, mak:verify-checklist §Self-Check, mak:review-report §Warning |
| **정밀한 수정** | 범위 밖 파일 금지 · 단일 목적 · 인접 코드 개선 금지 · 기존 스타일 일치 · 변경 라인=요청 직결 | mak:dev-kickoff §8, mak:verify-checklist §Self-Check, mak:review-report §Warning, mak:coder agent |
| **목표 중심적 실행** | 검증 가능한 목표로 전환 · `Step → verify: check` 계획 · 변경 후 검증 · 동작 확인 후 보고 | mak:dev-kickoff §5, mak:design-doc-template §5.0, mak:verify-checklist §Report Format |

## 3. `mak:roadmap-planning` — 프로젝트 로드맵 축

아래 5단계 개발 흐름과 **별개의 상위 축**으로 동작한다. 프로젝트 전체 방향(Phase 구조)을 먼저 잡은 뒤, 각 Phase 착수 시 5단계 흐름을 적용한다.

```
mak:roadmap-planning (프로젝트 초기 1회 + 주기적 갱신)
      │  Phase 선택
      ▼
[선택] mak:brainstorming → mak:dev-kickoff → [필요 시 mak:planner Brief]
      → mak:design-doc-template → 구현 → mak:verify-checklist → mak:review-report
```

## 4. 사용 시나리오 흐름 (단일 기능 / 큰 기능 분기)

**선행 분석을 한 문서로 담을 수 있는지**에 따라 **단일 design-doc 흐름** 과 **9-doc pack 흐름** 으로 분기한다 (다PR·다모듈 여부가 아니라 분석면 넓이 기준).

```
요구사항 접수
      │
      ▼
[선택] ① mak:brainstorming — 막연하거나 방향이 여러 갈래일 때만
      │ 방향 선택
      ▼
   ┌────────────────────────────┬──────────────────────────────────┐
   │ 단일 관심사 (분석 한 문서) │ 분석 분리 필요 / 다른 스택 이식  │
   ▼                            ▼
② mak:dev-kickoff →          ②' mak:major-feature-pack
   [필요 시 planner Brief]      (9개 문서: 02→01→03→04→05→06→07→08→00)
③ mak:design-doc-template        │ §08 의 PR Step 단위로
                                  │ ②~⑤ 흐름 반복 (9-doc = SSOT)
   │                              │
   └──────────┬───────────────────┘
              ▼
      ④ 구현 → mak:verify-checklist
              ▼
      ⑤ mak:review-report (수정 필요 시 ④ 재위임, 직접 수정 금지)
```

판단 기준:

| 신호 | design-doc-template | major-feature-pack |
| :--- | :--- | :--- |
| **선행 분석 분리 필요성** (핵심) | 한 문서로 담김 | 현상태·명세 gap·정책·데이터·계약을 분리 추적해야 함 |
| 외부/기존 시스템 정합 | 없음 또는 국소 | 필요 (현상태 vs 명세 + 의도적 차이 매트릭스) |
| 외부 정책/보안 결정 | 없음 또는 1건 | 다수 (TBD 항목 발생) |
| 다른 스택 이식 | — | 해당 |
| 데이터 모델 변경 | 단일 타입 | 매트릭스 단위 |

> **다PR·다모듈은 판별 기준이 아니다.** 단일 관심사의 다PR 작업(구조 리팩터 등)은 `mak:design-doc-template` 의 **마스터 문서(결정·PR 의존 그래프) + PR별 sub-doc** 로 처리한다.

## 5. 설치와 적용

```bash
claude plugin marketplace add blueclover222/mw_agent_kit   # 최초 1회
claude plugin install mak@mw-agent-kit
```

| 단계 | 명령/행동 | 효과 |
| :--- | :--- | :--- |
| 공통 규칙 설치 (1회) | `/mak:setup` | `~/.claude/CLAUDE.md` 에 Workflow 작업 등급·코딩 원칙 매핑·mak 위임 요약 마커 블록 추가. 재실행 시 블록만 갱신, 개인 규칙 비접촉 |
| 프로젝트 문서 세트 (선택) | `/mak:reverse-engineering` | 표준 문서 세트를 `docs/` 로 복사하고 코드 분석으로 채움 (compact/표준 프로파일) |
| 프로젝트 특화 규칙 (권장) | `<project>/.claude/CLAUDE.md` 직접 작성 | 검증 명령·문서 경로·도메인 규칙 등 프로젝트 고유 사항. skill 들이 이 파일을 우선 참조한다 |
| 제거 | `/mak:teardown` → `claude plugin uninstall` | 마커 블록 원복 후 삭제 |

설계 문서 기본 경로는 `.claude/mak/plan/` 이며, 프로젝트 `.claude/CLAUDE.md` 에 다른 경로를 명시하면 그쪽이 우선한다 (`mak:design-doc-template` §저장 경로가 SSOT).

> 기계적 강제(비밀 파일 read-deny, 검증 명령 allow, 훅 등)는 프로젝트·개인 환경마다 달라 플러그인에 포함하지 않는다. 필요하면 `~/.claude/settings.json` / `<project>/.claude/settings.json` 에서 직접 구성한다.

## 6. agent 와의 관계

| 상황 | 동작 방식 |
| :--- | :--- |
| `mak:planner` 사용 가능 | Non-trivial / Risky 작업에서 메인 스레드가 범위를 넘겨 Architecture Brief 를 요청. planner 는 옵션·권장안·리스크·결정 필요 사항을 보고하고, 결정 확정 후 설계 문서 집필을 한 번만 위임받는다. 사용자에게 질문하거나 결정을 확정하지 않는다 |
| `mak:coder` 사용 가능 | 설계 승인 후 구현 위임. Trivial / Small 은 명시 요청 시 설계 문서 없이 위임 가능. 9-doc pack 에서는 `08-implementation-plan.md` 의 PR Step 이 변경 범위 SSOT |
| `mak:reviewer` 사용 가능 | 단계 완료 후 검토 위임. 보고만 하고 코드 수정 금지 |
| `mak:doc-editor` 사용 가능 | 기능 완료 후 기존 문서 동기화 위임 |
| `mak:analyzer` 사용 가능 | `mak:reverse-engineering` 의 분석·문서 채움 단계를 배치 단위로 위임. 사실(is)만 기록, 코드 수정 금지. 대화형 결정(프로파일·덮어쓰기)과 문서 간 동기화 반영은 메인이 수행 |
| agent 위임 불가 환경 | 해당 skill 의 절차를 메인이 직접 수행 — skill 내부 자가 점검 게이트가 코딩 원칙(§2.2)을 강제 |

**위임 원칙**: 대화가 필요한 단계(요구사항 수렴·옵션 승인·설계 게이트)는 메인 스레드가 직접 수행한다(subagent 는 사용자와 대화 불가). 계획 승인 없이 `mak:coder` 를 호출하지 않는다. `mak:reviewer` 는 proactive 자동 호출 대상이 아니다.

## 7. 템플릿 커스터마이징

설치된 플러그인 파일은 직접 수정할 수 없다. 저장소를 fork 해 아래를 수정한 뒤 자체 마켓플레이스로 배포한다.

| 파일 | 커스터마이징 예시 |
| :--- | :--- |
| `skills/design-doc-template/assets/design-doc.template.md` | 프로젝트 고유 섹션 추가 (DB 스키마, API 명세 등) |
| `skills/review-report/assets/review-report.template.md` | 팀 규약에 맞는 등급 기준·필수 체크 항목 |
| `skills/roadmap-planning/assets/roadmap.template.md` | Phase 개수·상태 아이콘·네이밍 |
| `skills/reverse-engineering/assets/project_docs/` | 문서 세트 구성·스택 매핑 |
| `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` | 주입되는 공통 규칙 자체 (한/영 미러 — 함께 수정) |

템플릿 수정 시 `{{placeholder}}` 변수 구조를 유지하면 skill 이 채울 위치를 인식할 수 있다.

## 8. 운영 팁 (경량 모드·관측·회귀)

- **필요한 만큼만 쓴다** — Trivial / Small 위주 프로젝트라면 `mak:verify-checklist` 만으로 시작하고, 필요할 때 dev-kickoff → planner/reviewer 로 올린다. 문서 세트도 compact 프로파일로 시작한다.
- **관측** — 보고 전 자가검토(verify-checklist §자가 질의)를 습관화한다: 변경 라인=요청 직결? 범위 밖 수정 없나? 검증 수행했나?
- **회귀 점검** — fork 에서 skill/규칙을 고치면 대표 시나리오 2개로 흐름을 수동 확인한다: ① Trivial 작업이 게이트에 막히지 않는가 ② Non-trivial 새 기능이 "승인 전 구현 금지 / planner 는 자문만 / 집필 1회 / reviewer 코드 미수정" 을 지키는가.
- **메모리** — 반복되는 교정·선호·결정은 프로젝트 `CLAUDE.md` / `docs/` / Claude Code 메모리 중 적절한 곳에 누적한다.
