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
- The design-doc save-path rule has ONE home: `skills/design-doc-template/SKILL.md` §Save location (default `.claude/mak/plan/`). Other files reference "per the `mak:design-doc-template` save-path rule" instead of hardcoding paths
- The review procedure / report format has ONE home: `skills/review-report/SKILL.md`. `agents/reviewer.md` must not duplicate the procedure
- The task grades and the four coding principles have ONE home: `docs/guide.md §2.1 / §2.2`. The setup snippets inject copies of both (task-grade table from §2.1, principle mapping from §2.2) + the mak delegation summary — a change to either table must be synced across 4 places: guide ko/en + snippet ko/en. Skills/agents keep the "project/global Coding Rules take precedence" phrasing
- Skills that reference files inside the plugin use `${CLAUDE_PLUGIN_ROOT}`
- Frontmatter `description` carries trigger conditions only (when to use / when not to). Detailed criteria go in the body — descriptions are loaded into every session and cost tokens permanently
- Agent principle bullets (`agents/*.md`) start with a bold lead-in label (`- **Label** — detail`). Keep this emphasis structure uniform across all five agents

## Components

- 11 skills: brainstorming / dev-kickoff / design-doc-template / major-feature-pack / roadmap-planning / verify-checklist / review-report / commit / setup / teardown / reverse-engineering
- 5 agents: planner(opus) / coder(sonnet) / reviewer(opus) / doc-editor(haiku) / analyzer(opus) — coder/reviewer/planner load their companion skill via frontmatter `skills:`; analyzer follows the copied doc set's own rulebook (target `docs/CLAUDE.md`·`00.INDEX.md`) instead

## Verification Commands

This is a Markdown/JSON repository — no build or tests. After changes, run:

1. `claude plugin validate .` — manifest/structure validation
2. Consistency greps — all must return zero hits:
   - `grep -rn "~/.claude/skills" skills/ agents/` (old paths)
   - `grep -rn "\.claude/docs" skills/ agents/` (old design-doc path)
   - Bare (unprefixed) kit-skill names in backticks inside `skills/*/SKILL.md` and `agents/*.md`
   - `grep -rln '[가-힣]' skills/ agents/ | grep -v claude-md-snippet` (Korean residue outside the setup snippet)
3. Local smoke (on rule changes): `claude plugin marketplace add <repo path>` → `claude plugin install mak@mw-agent-kit` → check skills/agents appear. Note: with a same-version local marketplace, `plugin update` does NOT refresh the cache — bump `version` in plugin.json or uninstall/reinstall
4. On setup/teardown logic changes: simulate the inject → re-run (block replaced, no duplication) → remove round-trip against a scratch file

## Document Paths

- Design docs for this repository: `.claude/mak/plan/` (working documents; may be removed once their work is finished)

## Release

- Bump `version` in `.claude-plugin/plugin.json` (semver, 1.0.0 = first real release). **Bump only when shipped behavior changes** — the install cache is keyed by version, so a bump is exactly what makes an update reach installed users:
  - Major: breaks installed users — skill/agent renames, marker-format or snippet-contract changes, save-path default changes
  - Minor: new skills / agents / capabilities
  - Patch: fixes inside existing skills/agents that change what the model does (procedure, gates, rule wording)
  - **No bump**: repo-documentation-only changes (README, docs/guide, contributor docs) — a stale cached copy of these is harmless, and they are read from the repo/GitHub anyway
- The marketplace name `mw-agent-kit` and plugin name `mak` must not change (installed users' references would break)
- When the `claude-md-snippet.ko.md` / `.en.md` pair changes, confirm the README note "re-run /mak:setup after updates" still holds
