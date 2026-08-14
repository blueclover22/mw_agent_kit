<!-- mak:begin — managed by mak:setup; do not edit inside this block. Remove with /mak:teardown -->

# mak — 공통 개발 규칙

> 이 블록은 `mak` 플러그인의 `/mak:setup` 이 관리한다. 수정은 플러그인 저장소에서, 제거는 `/mak:teardown` 으로 한다.
> mak 플러그인이 설치되어 있지 않은 환경에서는 이 블록의 `mak:*` skill·agent 참조를 무시하고, 등급·원칙 등 일반 규칙만 적용한다.
> 아래 작업 등급과 코딩 원칙은 **기본값**이다 — 마커 밖(사용자 영역)이나 프로젝트 CLAUDE.md 에 자체 Coding Rules·작업 분류 기준이 있으면 그것이 우선한다.

## Workflow

작업은 먼저 크기와 위험도로 분류한다. 이 등급이 `mak:dev-kickoff` 진입과 `mak:planner` 자문 여부를 결정한다.

| 등급 | 기준 | 기본 흐름 |
| :--- | :--- | :--- |
| **Trivial** | 오타·포맷·주석·1줄 수정·명백한 단일 파일 독립 수정 | 설계 문서·승인 게이트 없이 기존 파일을 읽고 바로 수정. 필요 시 `mak:coder` 사용 |
| **Small** | 영향 범위가 작고 되돌리기 쉬운 버그 수정·소규모 동작 변경 | 짧은 변경 의도와 검증 방법을 공유한 뒤 진행. 보통 `mak:dev-kickoff` 생략 (버그는 재현·검증 유지) |
| **Non-trivial** | 여러 파일·모듈 영향, 새 기능·컴포넌트, 구조 선택이 필요한 변경 | `mak:dev-kickoff` 로 착수. 기존 구조가 복잡하거나 선택지가 갈리면 `mak:planner` Architecture Brief 요청 |
| **Risky** | 데이터 모델·의존성·보안·배포·마이그레이션·다중 모듈 영향 | `mak:dev-kickoff` + `mak:planner` Architecture Brief 원칙적 사용 |

- 등급이 애매하면 영향 범위로 판단한다 — 단일 파일·소수 라인이고 공개 인터페이스·데이터 형태·의존성 변화가 없으면 Trivial / Small, 2개 이상 파일·모듈에 걸치거나 인터페이스·데이터 모델·의존성·보안이 바뀌면 Non-trivial 이상
- Non-trivial / Risky 는 구현 전 분석·설계 계획을 작성하고 사용자 승인을 받는다 — 승인 전에는 구현하지 않는다
- 계획 작성 및 설계 진행 시 선택이나 승인이 필요한 사항은 옵션·장단점·권장안을 함께 제시한다
- 계획 작성 및 설계 진행 시 관련 코드와 기존 패턴을 먼저 파악한다
- 작업 도중 범위가 여러 파일/모듈로 번지면 등급을 올려 `mak:dev-kickoff` 로 전환한다
- mak 흐름에서 산출되는 문서(설계 문서·리뷰 보고서·로드맵 등)는 템플릿 언어(영어)와 무관하게 **사용자 대화 언어로 작성**한다. 프로젝트 규칙 문서에 별도 언어 정책이 있으면 그것이 우선한다

## 코딩 원칙 매핑

| 원칙 | 핵심 행동 | 강제 게이트 |
| :--- | :--- | :--- |
| **코딩하기 전에 생각하기** | 가정 명시("추정") · 다중 해석 모두 제시 · 더 단순한 대안 제안/반박 · 이해 안 되면 멈춤·질문 | mak:brainstorming §Procedure 3·5, mak:dev-kickoff §2·§3·§4, mak:planner Brief, mak:design-doc-template §Quality Checklist |
| **단순함이 최우선** | 미요청 기능·추측성 유연성·발생 불가 오류 처리 금지 · 단순한 대안 포함 | mak:dev-kickoff §3·§4·§8, mak:planner Brief, mak:design-doc-template §Quality Checklist, mak:verify-checklist §Self-Check, mak:review-report §Warning |
| **정밀한 수정** | 범위 밖 파일 금지 · 단일 목적 · 인접 코드 개선 금지 · 기존 스타일 일치 · 변경 라인=요청 직결 | mak:dev-kickoff §8, mak:verify-checklist §Self-Check, mak:review-report §Warning, mak:coder agent |
| **목표 중심적 실행** | 검증 가능한 목표로 전환 · `Step → verify: check` 계획 · 변경 후 검증 · 동작 확인 후 보고 | mak:dev-kickoff §5·§10, mak:design-doc-template §5.0, mak:verify-checklist §Self-Check·§Report Format |

## mak 위임 규칙

각 skill·agent 를 **언제** 부르는지는 그 description 에 있다. 여기서는 그것들 사이의 순서·관계·제약만 정한다.

- 개발 주기 — `mak:brainstorming`(발산) → `mak:dev-kickoff`(착수·승인 게이트) → `mak:design-doc-template`(설계 문서화) → 구현 → `mak:verify-checklist`(검증) → `mak:review-report`(리뷰). 상위 축은 `mak:roadmap-planning`. agent 는 `mak:planner` / `mak:coder` / `mak:reviewer` / `mak:doc-editor` / `mak:analyzer`.
- 주기 밖 진입점 — `mak:dev-resume`(작업 재개), `mak:doc-audit`(문서 간 정합성), `mak:reverse-engineering`(문서 세트가 없는 기존 프로젝트). 셋 다 주기의 단계가 아니므로 매 사이클마다 부르지 않는다.
- `mak:commit` 은 주기가 자동으로 잇지 않는다 — 사용자 명시 요청 시에만 진입한다(skill 실행이 곧 명시적 커밋 요청, push 등 기타 git 명령은 별도 명시 요청 시에만).
- 다단계 작업의 진행 기록은 설계 문서 §5.0 `Step → verify` 표의 Status 열이다 — Step 이 verify 를 통과할 때마다 구현 주체(`mak:coder` 또는 메인)가 갱신하고, `mak:dev-resume` 이 재개 시 이 열을 읽는다.
- 대화가 필요한 단계(요구사항 수렴·옵션 승인·설계 게이트)는 메인 스레드가 직접 수행한다. subagent 는 사용자와 대화할 수 없다.
- 계획 승인 없이 `mak:coder` 를 호출하지 않는다 (단순 작업은 명시 요청 시 예외). `mak:reviewer` 와 `mak:analyzer` 는 보고만 하고 대상을 수정하지 않는다.
- 설계 문서 집필은 한 번만 한다 — `mak:planner` 가 사용 가능하면 확정된 결정을 전달해 집필을 위임하고, 없으면 메인이 직접 작성한다. 기존 Markdown 문서의 편집·동기화는 `mak:doc-editor` 로 위임한다.
- 설계 문서는 `mak:design-doc-template` 의 경로 규칙(기본 `.claude/mak/plan/`)을 따른다.

<!-- mak:end -->
