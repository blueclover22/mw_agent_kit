<!-- mak:begin — managed by mak:setup; do not edit inside this block. Remove with /mak:teardown -->

# mak — Common Development Rules

> The task grades and coding principles below are **defaults** — if your own Coding Rules or task classification exist outside the markers or in a project CLAUDE.md, those take precedence. In an environment without the mak plugin, ignore the `mak:*` references and apply only the rest.

## Workflow

| Grade | Criteria | Default flow |
| :--- | :--- | :--- |
| **Trivial** | Typos, formatting, comments, one-liners, obvious independent single-file fixes | Read the existing file and fix directly — no design doc or approval gate. Delegate to `mak:coder` only when the user asks |
| **Small** | Small-impact, easily reversible bug fixes / minor behavior changes | Share brief change intent + verification method, then proceed. Usually skip `mak:dev-kickoff` (keep bug reproduction/verification) |
| **Standard** | Multiple files/modules, new features/components, structural choices | Enter via `mak:dev-kickoff`. Request a `mak:planner` Architecture Brief when the structure is complex or options genuinely diverge |
| **Risky** | Data model, dependencies, security, deployment, migration | `mak:dev-kickoff` + `mak:planner` Architecture Brief as a rule |

- On receiving a development request, declare the grade in one line before starting — e.g. `[Standard] → mak:dev-kickoff`. Never enter implementation without that declaration
- When the grade is unclear, judge by impact — single file / few lines with no change to public interfaces, data shapes, or dependencies → Trivial / Small; spanning 2+ files/modules or changing interfaces, data models, dependencies, or security → Standard or above
- Standard / Risky: write an analysis/design plan and get user approval before implementation — never implement before approval
- If scope spreads across multiple files/modules mid-work, upgrade the grade and switch to `mak:dev-kickoff`
- mak-flow documents use the user's language; project language policy wins

## Coding-Principle Mapping

| Principle | Core behaviors |
| :--- | :--- |
| **Think before coding** | Mark assumptions ("Assumption") · present all interpretations · propose/push back with simpler alternatives · stop and ask when confused |
| **Simplicity first** | No unrequested features, speculative flexibility, or impossible-scenario error handling · include simpler alternatives |
| **Precise changes** | No out-of-scope files · single purpose per change · no adjacent "improvements" · match existing style · every changed line ties to the request |
| **Goal-driven execution** | Convert to verifiable goals · `Step → verify: check` plans · verify after changes · confirm behavior before reporting |

## mak Delegation Rules

The user who installed this block has **pre-approved subagent delegation** in the mak flow — when a task meets the criteria below, the main thread launches the agent without further confirmation. Delegate only sizeable, independent, parallelizable work, bulk investigation or output that would crowd the main context, or a role an agent's description assigns. Do not delegate what a handful of tool calls can finish, and do not use a subagent to re-check your own work — stage-completion review of Standard-or-above work and user-requested review are the exceptions.

**When** to invoke each skill/agent is in its own description. This section fixes only the entry points and the order/constraints between them.

| User request | Entry point |
| :--- | :--- |
| Requirements unclear or the direction genuinely diverges | `mak:brainstorming` → `mak:dev-kickoff` |
| Any other development request | Declare the grade → the default flow of the §Workflow grade table |
| Before reporting an implementation/change done (when verification commands are declared, or on request) | `mak:verify-checklist` |
| Reviewing a completed Standard-or-above stage, or an explicit code/PR review request | `mak:review-report` |
| Right after a slice/phase completes, at a phase transition, before handing off an unfinished session | `mak:doc-audit` |
| Mid/long-term direction and priorities across phases | `mak:roadmap-planning` |
| External-source research and producing a research document | `mak:researcher` — the main thread assigns the path (project rules win; default `docs/research/`) |
| Editing/syncing Markdown documents, or creating one the main thread specifies | `mak:doc-editor` |
| Resuming work with no decided next task / a project with no doc set / committing | `mak:dev-resume` / `mak:reverse-engineering` / `mak:commit` |

> When a request matches several rows, follow the first one from the top. The verify / review / audit rows are sequential stages when their conditions hold, though — not exclusive choices.

- Development cycle — `mak:brainstorming` → `mak:dev-kickoff` → `mak:design-doc-template` → implement → `mak:verify-checklist` → `mak:review-report`
- `mak:commit` runs only on explicit user request
- Conversation stages (requirements, option approval, design gates) and design-doc/roadmap writing are main-thread work
- Investigation-only delegations (`mak:planner`, `mak:reviewer`, `mak:auditor`) run concurrently when scopes are disjoint; concurrent ones get no verification commands
- Writing delegations (`mak:coder`, `mak:doc-editor`, `mak:analyzer`, `mak:researcher`) run in parallel only on disjoint write targets; the main thread then updates §5.0 Status, verifies, and merges

<!-- mak:end -->
