# CLAUDE.md — Development Rules for the mak Plugin Repository

This repository IS the Claude Code plugin `mak`. There is no source code — everything is Markdown / JSON.
The repository root is the plugin root; the manifest lives at `.claude-plugin/plugin.json`.

## Language Policy

- `skills/*/SKILL.md` and `agents/*.md` instructions / frontmatter descriptions — **English**
- `skills/*/assets/` templates and doc sets — **English** (output language is delegated to each skill's "follow the user's language" note)
  - **Exception**: `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` — a **Korean/English mirror pair** injected verbatim into `~/.claude/CLAUDE.md` (mak:setup picks by the user's language). **Edit both together**; markers must stay identical across the pair
- `README.md` / `docs/guide.md` — Korean by default, with English twins `README.en.md` / `docs/guide.en.md`. **Editing one side requires syncing the other**
- This file and `AGENTS.md` — English

## Reference Rules (consistency invariants)

- Cross-references between skills/agents always use the `mak:`-prefixed name (`mak:dev-kickoff`). Bare names are forbidden
- Agent availability is phrased as "if the agent is in the available agent list" — never as a `.claude/agents/*.md` file-existence check
- The design-doc save-path rule has ONE home: `skills/design-doc-template/SKILL.md` §Save location. Skills and agents must attribute it ("per the `mak:design-doc-template` save-path rule") and may restate the default for readability; user-facing docs (README, guide) may state the default plainly. The rule text itself lives only in the home. Changing the default means updating every restatement — grep `.claude/mak/plan/` to find them
- An agent that loads a companion skill via frontmatter `skills:` must not restate that skill's procedure, order, or report format — point at the section instead.
- The task grades and the four coding principles have ONE home: `docs/guide.md §2.1 / §2.2`. The setup snippets inject copies of both (task-grade table from §2.1, principle mapping from §2.2) + the mak delegation rules — a change to either table must be synced across 4 places: guide ko/en + snippet ko/en. Skills/agents keep the "project/global Coding Rules take precedence" phrasing
- Every tool in an agent's `tools:` beyond Read/Grep/Glob must have its allowed use stated in that agent's body. **`Bash` counts as a write vector** — an agent claiming "never modifies" while holding it must say what it may and may not do
- A procedure whose steps can be split between the main thread and a delegated agent must name the performer per step. When it lives in `skills/*/assets/`, that naming belongs in the asset — it is read in the target project, where the delegating agent's instructions are not present
- Skills that reference files inside the plugin use `${CLAUDE_PLUGIN_ROOT}`
- Frontmatter `description` carries trigger conditions only (when to use / when not to). Detailed criteria go in the body — descriptions are loaded into every session and cost tokens permanently. **Agent descriptions are the exception**: the orchestrator picks an agent from its description alone, so capability and constraint wording ("reads source and fills docs", "never modifies code") is functional there and stays
- Agent principle bullets (`agents/*.md`) start with a bold lead-in label (`- **Label** — detail`). Keep this emphasis structure uniform across all agents
- A reference that **forbids** routing to a component (rather than pointing at it) must be phrased `Never route into \`mak:<name>\`` — the fixed wording is what lets the connectivity check (`docs/maintenance.md` §Conditional Verification) tell a prohibition apart from a real handoff. Both read as `mak:<name>` to grep, so an unmarked prohibition silently counts as an inbound edge and hides an orphan. Currently the only one is `skills/verify-checklist/SKILL.md` → `mak:commit`
- `agents/coder.md`, `agents/reviewer.md`, `agents/auditor.md` load their companion skill via frontmatter `skills:`; `agents/analyzer.md` must NOT — it follows the copied doc set's own rulebook (target `docs/CLAUDE.md`·`00.INDEX.md`) instead
- The marketplace name `mw-agent-kit` and the plugin name `mak` must never change — installed users' references would break

## Maintenance Procedures

- Adding or removing a skill / agent, and cutting a release: read `docs/maintenance.md` first — both are multi-file syncs

## Verification Commands

This is a Markdown/JSON repository — no build or tests. Run 1–2 after every change; the rest are conditional and their procedures live in `docs/maintenance.md`. This list is what tells you when to go read them.

1. `claude plugin validate .` — manifest/structure validation
2. Consistency greps — all must return zero hits:
   - `grep -rn "~/.claude/skills" skills/ agents/` (old paths)
   - `grep -rn "\.claude/docs" skills/ agents/` (old design-doc path)
   - `grep -rln '[가-힣]' skills/ agents/ | grep -v claude-md-snippet` (Korean residue outside the setup snippet)
   - Bare (unprefixed) skill/agent names in backticks — match-level, not line-level, so a bare name on the same line as a prefixed one is still caught:

     ```
     for n in $(ls -d skills/*/ | xargs -n1 basename) $(ls agents/*.md | xargs -n1 basename | sed 's/.md//'); do
       grep -rHoE "\`$n\`" skills/*/SKILL.md agents/*.md
     done
     ```

**Conditional** — when one of these applies, run the matching procedure in `docs/maintenance.md` §Conditional Verification:

| Trigger | Check |
| :--- | :--- |
| A skill/agent added, removed, or rewired | Graph connectivity (SINK / ORPHAN) |
| `skills/` · `agents/` · manifest changed (what actually ships) | Local smoke install |
| `skills/setup/` or `skills/teardown/` logic changed | setup → re-run → teardown round-trip |
| `skills/reverse-engineering/assets/` changed | Compact-profile closure + `related_to` symmetry |

## Document Paths

- Design docs for this repository: `.claude/mak/plan/` (working documents; may be removed once their work is finished)
