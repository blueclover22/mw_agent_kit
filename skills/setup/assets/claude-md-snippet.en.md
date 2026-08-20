<!-- mak:begin — managed by mak:setup; do not edit inside this block. Remove with /mak:teardown -->

# mak — Common Development Rules

> The task grades and coding principles below are **defaults** — if your own Coding Rules or task classification exist outside the markers or in a project CLAUDE.md, those take precedence. In an environment without the mak plugin, ignore the `mak:*` references and apply only the rest.

## Workflow

| Grade | Criteria | Default flow |
| :--- | :--- | :--- |
| **Trivial** | Typos, formatting, comments, one-liners, obvious independent single-file fixes | Read the existing file and fix directly — no design doc or approval gate. Use `mak:coder` if desired |
| **Small** | Small-impact, easily reversible bug fixes / minor behavior changes | Share brief change intent + verification method, then proceed. Usually skip `mak:dev-kickoff` (keep bug reproduction/verification) |
| **Standard** | Multiple files/modules, new features/components, structural choices | Enter via `mak:dev-kickoff`. Request a `mak:planner` Architecture Brief when the structure is complex or options genuinely diverge |
| **Risky** | Data model, dependencies, security, deployment, migration | `mak:dev-kickoff` + `mak:planner` Architecture Brief as a rule |

- On receiving a development request, declare the grade in one line before starting — e.g. `[Standard] → mak:dev-kickoff`. Never enter implementation without that declaration
- When the grade is unclear, judge by impact — single file / few lines with no change to public interfaces, data shapes, or dependencies → Trivial / Small; spanning 2+ files/modules or changing interfaces, data models, dependencies, or security → Standard or above
- Standard / Risky: write an analysis/design plan and get user approval before implementation — never implement before approval
- When planning or designing, understand the related code and existing patterns first, and present options, trade-offs, and a recommendation for anything requiring a choice or approval
- If scope spreads across multiple files/modules mid-work, upgrade the grade and switch to `mak:dev-kickoff`
- Documents produced through the mak flow are **written in the user's conversation language**, regardless of the templates' language. A language policy stated in the project's rule documents takes precedence

## Coding-Principle Mapping

| Principle | Core behaviors |
| :--- | :--- |
| **Think before coding** | Mark assumptions ("Assumption") · present all interpretations · propose/push back with simpler alternatives · stop and ask when confused |
| **Simplicity first** | No unrequested features, speculative flexibility, or impossible-scenario error handling · include simpler alternatives |
| **Precise changes** | No out-of-scope files · single purpose per change · no adjacent "improvements" · match existing style · every changed line ties to the request |
| **Goal-driven execution** | Convert to verifiable goals · `Step → verify: check` plans · verify after changes · confirm behavior before reporting |

## mak Delegation Rules

The user who installed this block has **requested subagent use in advance** as a standing request throughout the mak flow — this is taken as already satisfying "only call a subagent when the user requested it". When a task meets this section's rules and the agent's own description conditions, the main thread launches the agent without further confirmation.

**When** to invoke each skill/agent is in its own description. This section fixes only the entry points and the order/constraints between them.

| User request | Entry point |
| :--- | :--- |
| Requirements unclear or the direction genuinely diverges | `mak:brainstorming` → `mak:dev-kickoff` |
| Any other development request | Declare the grade → the default flow of the §Workflow grade table |
| Immediately after an implementation/change completes | `mak:verify-checklist` |
| Reviewing a completed stage, or an explicit code/PR review request | `mak:review-report` |
| Right after a slice/phase completes, at a phase transition, before handing off an unfinished session | `mak:doc-audit` |
| Mid/long-term direction and priorities across phases | `mak:roadmap-planning` |
| Editing or syncing existing Markdown documents | `mak:doc-editor` |
| Resuming work with no decided next task / a project with no doc set / committing | `mak:dev-resume` / `mak:reverse-engineering` / `mak:commit` |

> When a request matches several rows, follow the first one from the top. The verify / review / audit rows are sequential stages, though — not exclusive choices.

- Development cycle — `mak:brainstorming` → `mak:dev-kickoff` → `mak:design-doc-template` → implement → `mak:verify-checklist` → `mak:review-report`
- `mak:dev-resume`, `mak:doc-audit`, and `mak:reverse-engineering` are not stages of the cycle — never run them every iteration
- `mak:commit` is not chained from the cycle — it is entered only on the user's explicit request (invoking the skill is the explicit commit request; other git ops such as push need their own explicit request).
- Progress on multi-step work is recorded in the design doc's §5.0 `Step → verify` Status column — whoever implements the step advances it as each verify criterion passes
- Stages requiring conversation (requirements convergence, option approval, design gates) are performed by the main thread; subagents cannot talk to the user.
- Trivial / Small work may be delegated to `mak:coder` without an approved plan; Standard and above only after design approval. Whatever the grade, changes made by `mak:coder` go through `mak:review-report` once `mak:verify-checklist` passes.
- Design docs are written once, by the main thread. Editing/syncing existing Markdown documents is delegated to `mak:doc-editor`.
- Design docs follow the `mak:design-doc-template` save-path rule (default `.claude/mak/plan/`).
- Investigation-only delegations (`mak:planner`, `mak:reviewer`, `mak:auditor`) are read-only, and are invoked concurrently in a single message when their investigation scopes do not overlap — overlapping scopes duplicate the same work, so split the scope and invoke sequentially instead. Splitting review by module or dimension is the typical case. Never hand verification commands to delegations invoked concurrently — their outputs collide.
- Writing delegations (`mak:coder`, `mak:doc-editor`, `mak:analyzer`) are first judged for disjoint write targets, and run in parallel when they are disjoint — overlapping targets collide, so split them serially. The disjointness criterion is the design doc's §Scope of Changes, the target document list, and the assigned document set respectively. When they run in parallel, the main thread takes over updating the design doc's §5.0 Status and running verification — so no two delegations touch the same row or the same command.
- The main thread merges the results of parallel delegation — subagents do not know what the others found, so pack every piece of needed context into each delegation

<!-- mak:end -->
