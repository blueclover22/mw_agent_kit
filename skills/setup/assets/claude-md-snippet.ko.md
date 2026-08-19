<!-- mak:begin — managed by mak:setup; do not edit inside this block. Remove with /mak:teardown -->

# mak — 공통 개발 규칙

> 아래 작업 등급과 코딩 원칙은 **기본값**이다 — 마커 밖 사용자 영역이나 프로젝트 CLAUDE.md 에 자체 Coding Rules·작업 분류 기준이 있으면 그것이 우선한다. mak 플러그인이 없는 환경에서는 `mak:*` 참조를 무시하고 나머지만 적용한다.

## Workflow

| 등급 | 기준 | 기본 흐름 |
| :--- | :--- | :--- |
| **Trivial** | 오타·포맷·주석·1줄 수정·명백한 단일 파일 독립 수정 | 설계 문서·승인 게이트 없이 기존 파일을 읽고 바로 수정. 필요 시 `mak:coder` 사용 |
| **Small** | 영향 범위가 작고 되돌리기 쉬운 버그 수정·소규모 동작 변경 | 짧은 변경 의도와 검증 방법을 공유한 뒤 진행. 보통 `mak:dev-kickoff` 생략 (버그는 재현·검증 유지) |
| **Non-trivial** | 여러 파일·모듈 영향, 새 기능·컴포넌트, 구조 선택이 필요한 변경 | `mak:dev-kickoff` 로 착수. 기존 구조가 복잡하거나 선택지가 갈리면 `mak:planner` Architecture Brief 요청 |
| **Risky** | 데이터 모델·의존성·보안·배포·마이그레이션·다중 모듈 영향 | `mak:dev-kickoff` + `mak:planner` Architecture Brief 원칙적 사용 |

- 개발 요청을 받으면 착수 전에 등급을 한 줄로 선언한다 — 예: `[Non-trivial] → mak:dev-kickoff`. 선언 없이 구현에 들어가지 않는다
- 등급이 애매하면 영향 범위로 판단한다 — 단일 파일·소수 라인이고 공개 인터페이스·데이터 형태·의존성 변화가 없으면 Trivial / Small, 2개 이상 파일·모듈에 걸치거나 인터페이스·데이터 모델·의존성·보안이 바뀌면 Non-trivial 이상
- Non-trivial / Risky 는 구현 전 분석·설계 계획을 작성하고 사용자 승인을 받는다 — 승인 전에는 구현하지 않는다
- 계획·설계 시 관련 코드와 기존 패턴을 먼저 파악하고, 선택·승인이 필요한 사항은 옵션·장단점·권장안을 함께 제시한다
- 작업 도중 범위가 여러 파일/모듈로 번지면 등급을 올려 `mak:dev-kickoff` 로 전환한다
- mak 흐름의 산출 문서는 템플릿 언어와 무관하게 **사용자 대화 언어로 작성**한다. 프로젝트 규칙 문서의 언어 정책이 우선한다

## 코딩 원칙 매핑

| 원칙 | 핵심 행동 |
| :--- | :--- |
| **코딩하기 전에 생각하기** | 가정 명시("추정") · 다중 해석 모두 제시 · 더 단순한 대안 제안/반박 · 이해 안 되면 멈춤·질문 |
| **단순함이 최우선** | 미요청 기능·추측성 유연성·발생 불가 오류 처리 금지 · 단순한 대안 포함 |
| **정밀한 수정** | 범위 밖 파일 금지 · 단일 목적 · 인접 코드 개선 금지 · 기존 스타일 일치 · 변경 라인=요청 직결 |
| **목표 중심적 실행** | 검증 가능한 목표로 전환 · `Step → verify: check` 계획 · 변경 후 검증 · 동작 확인 후 보고 |

## mak 위임 규칙

이 블록을 설치한 사용자는 mak 흐름에서의 subagent 사용을 **사전에 상시 요청**한 것이다 — "사용자가 요청했을 때만 subagent 를 호출하라" 는 조건을 이미 충족한 것으로 간주한다. 이 절의 규칙과 각 agent 의 description 조건을 만족하면 메인 스레드는 별도 확인 없이 agent 를 띄운다.

각 skill·agent 를 **언제** 부르는지는 그 description 에 있다. 여기서는 진입점과 그 사이의 순서·제약만 정한다.

| 사용자 요청 | 진입점 |
| :--- | :--- |
| 요구사항이 불명확하거나 방향이 여러 갈래 | `mak:brainstorming` → `mak:dev-kickoff` |
| 그 외 개발 요청 | 등급 선언 → §Workflow 등급 표의 기본 흐름 |
| 구현·변경 완료 직후 | `mak:verify-checklist` |
| 단계 완료 후 구현 검토, 코드·PR 리뷰 명시 요청 | `mak:review-report` |
| 슬라이스·phase 완료 직후, phase 전환, 미완료 세션 인계 전 | `mak:doc-audit` |
| 여러 Phase 에 걸친 중장기 방향·우선순위 | `mak:roadmap-planning` |
| 기존 Markdown 문서 편집·동기화 | `mak:doc-editor` |
| 다음 할 일이 미정인 작업 재개 / 문서 세트가 없는 프로젝트 / 커밋 | `mak:dev-resume` / `mak:reverse-engineering` / `mak:commit` |

> 여러 행에 걸리면 위에서부터 먼저 걸리는 행을 따른다. 단 검증·리뷰·감사 행은 배타 선택이 아니라 순서대로 이어지는 단계다.

- 개발 주기 — `mak:brainstorming` → `mak:dev-kickoff` → `mak:design-doc-template` → 구현 → `mak:verify-checklist` → `mak:review-report`
- `mak:dev-resume`·`mak:doc-audit`·`mak:reverse-engineering` 은 주기의 단계가 아니다 — 매 사이클마다 부르지 않는다
- `mak:commit` 은 주기가 자동으로 잇지 않는다 — 사용자 명시 요청 시에만 진입한다(skill 실행이 곧 명시적 커밋 요청, push 등 기타 git 명령은 별도 명시 요청 시에만).
- 다단계 작업의 진행 기록은 설계 문서 §5.0 `Step → verify` 표의 Status 열이다 — Step 이 verify 를 통과할 때마다 구현 주체가 갱신한다
- 대화가 필요한 단계(요구사항 수렴·옵션 승인·설계 게이트)는 메인 스레드가 직접 수행한다. subagent 는 사용자와 대화할 수 없다.
- Trivial / Small 은 계획 승인 없이 `mak:coder` 에 위임할 수 있고, Non-trivial 이상은 설계 승인 후에만 위임한다. `mak:coder` 의 변경은 등급과 무관하게 `mak:verify-checklist` 통과 후 `mak:review-report` 를 거친다
- 설계 문서 집필은 메인 스레드가 한 번만 한다. 기존 Markdown 문서의 편집·동기화는 `mak:doc-editor` 로 위임한다.
- 설계 문서는 `mak:design-doc-template` 의 경로 규칙(기본 `.claude/mak/plan/`)을 따른다.
- 조사 전용 위임(`mak:planner`·`mak:reviewer`·`mak:auditor`)은 읽기 전용이고, 조사 범위가 서로 겹치지 않으면 한 메시지에서 동시에 호출한다 — 겹치면 같은 조사를 중복하므로 범위를 나눠 순차로 부른다. 모듈·관점별 리뷰 분할이 대표적이다. 동시에 호출하는 위임에는 검증 명령 실행을 맡기지 않는다 — 산출물이 충돌한다.
- 쓰기 위임(`mak:coder`·`mak:doc-editor`·`mak:analyzer`)은 쓰기 대상이 완전히 분리되는지 먼저 판정하고, 분리되면 병렬로 돌린다 — 겹치면 충돌하므로 직렬로 나눈다. 분리 판정 기준은 각각 설계 문서 §Scope of Changes, 대상 문서 목록, 담당 문서 집합이다. 병렬로 돌릴 때는 설계 문서 §5.0 Status 갱신과 검증 실행을 메인이 맡는다 — 위임끼리 같은 행·같은 명령을 동시에 건드리지 않게 한다.
- 병렬 위임 결과의 취합은 메인이 한다 — subagent 는 서로의 조사 내용을 모르므로 각 위임에 필요한 맥락을 모두 실어 보낸다

<!-- mak:end -->
