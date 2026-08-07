<!-- mak:begin — managed by mak:setup; do not edit inside this block. Remove with /mak:teardown -->

# mak — Common Development Rules

> This block is managed by the `mak` plugin's `/mak:setup`. Edit it in the plugin repository; remove it with `/mak:teardown`.
> If the mak plugin is not installed in this environment, ignore the `mak:*` skill/agent references in this block and apply only the general rules (grades, principles).

## Workflow

Classify work by size and risk first. The grade decides whether to enter `mak:dev-kickoff` and whether to consult `mak:planner`.

| Grade | Criteria | Default flow |
| :--- | :--- | :--- |
| **Trivial** | Typos, formatting, comments, one-liners, obvious independent single-file fixes | Read the existing file and fix directly — no design doc or approval gate. Use `mak:coder` if desired |
| **Small** | Small-impact, easily reversible bug fixes / minor behavior changes | Share brief change intent + verification method, then proceed. Usually skip `mak:dev-kickoff` (keep bug reproduction/verification) |
| **Non-trivial** | Multiple files/modules, new features/components, structural choices | Enter via `mak:dev-kickoff`. Request a `mak:planner` Architecture Brief when the structure is complex or options genuinely diverge |
| **Risky** | Data model, dependencies, security, deployment, migration, multi-module impact | `mak:dev-kickoff` + `mak:planner` Architecture Brief as a rule |

- When the grade is unclear, judge by impact — single file / few lines with no change to public interfaces, data shapes, or dependencies → Trivial / Small; spanning 2+ files/modules or changing interfaces, data models, dependencies, or security → Non-trivial or above
- Non-trivial / Risky: write an analysis/design plan and get user approval before implementation — never implement before approval
- When planning or designing, present options, trade-offs, and a recommendation for anything requiring a choice or approval
- When planning or designing, understand the related code and existing patterns first
- If scope spreads across multiple files/modules mid-work, upgrade the grade and switch to `mak:dev-kickoff`
- Documents produced through the mak flow (design docs, review reports, roadmaps, etc.) are **written in the user's conversation language**, regardless of the templates' language (English). A language policy stated in the project's rule documents takes precedence

## Coding-Principle Mapping

| Principle | Core behaviors | Enforcement gates |
| :--- | :--- | :--- |
| **Think before coding** | Mark assumptions ("Assumption") · present all interpretations · propose/push back with simpler alternatives · stop and ask when confused | mak:brainstorming §3·§5, mak:dev-kickoff §2·§3·§4, mak:planner Brief, mak:design-doc-template §Quality Checklist |
| **Simplicity first** | No unrequested features, speculative flexibility, or impossible-scenario error handling · include simpler alternatives | mak:dev-kickoff §3·§4·§8, mak:planner Brief, mak:design-doc-template §Quality Checklist, mak:verify-checklist §Self-Check, mak:review-report §Warning |
| **Precise changes** | No out-of-scope files · single purpose per change · no adjacent "improvements" · match existing style · every changed line ties to the request | mak:dev-kickoff §8, mak:verify-checklist §Self-Check, mak:review-report §Warning, mak:coder agent |
| **Goal-driven execution** | Convert to verifiable goals · `Step → verify: check` plans · verify after changes · confirm behavior before reporting | mak:dev-kickoff §5, mak:design-doc-template §5.0, mak:verify-checklist §Report Format |

## mak Delegation Summary

- Development-process skills/agents come from the `mak` plugin — skills: `mak:brainstorming` (diverge) → `mak:dev-kickoff` (kickoff, approval gate) → `mak:design-doc-template` (design documentation) → `mak:verify-checklist` (verification) → `mak:review-report` (review) → `mak:doc-audit` (cross-document consistency audit) → `mak:commit` (wrap-up commit — invoking the skill is the explicit commit request; other git ops such as push run only on explicit request); top-level axis `mak:roadmap-planning`. Agents: `mak:planner` / `mak:coder` / `mak:reviewer` / `mak:doc-editor` / `mak:analyzer`. Follow each mak skill/agent description for flow details.
- Stages requiring conversation (requirements convergence, option approval, design gates) are performed by the main thread; subagents cannot talk to the user.
- Never invoke `mak:coder` without an approved plan (simple work on explicit request is the exception). `mak:reviewer` reports only and never modifies code.
- Design docs are written once — if `mak:planner` is available, delegate the writing with the confirmed decisions; otherwise the main thread writes it directly.
- Simple typo/format cleanups of existing Markdown documents are delegated to `mak:doc-editor`.
- Design docs follow the `mak:design-doc-template` save-path rule (default `.claude/mak/plan/`).

<!-- mak:end -->
