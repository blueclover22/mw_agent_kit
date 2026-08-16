# AGENTS.md — Working on the mak Plugin Repository

This repository IS the Claude Code plugin `mak` (repo root = plugin root; manifest at `.claude-plugin/plugin.json`). Everything is Markdown / JSON — no build, no tests.

Development rules are split across two files: [CLAUDE.md](CLAUDE.md) holds the reference rules and the full verification command set; this file restates the invariants you must not break and owns §Git. Run the complete checks from `CLAUDE.md` §Verification Commands.

## Language policy

- `skills/*/SKILL.md` and `agents/*.md` instructions/descriptions: **English**
- `skills/*/assets/` templates and doc sets: **English** (output language is delegated to "follow the user's language" notes in skills)
  - **Exception**: `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` — a **Korean/English mirror pair** injected verbatim into `~/.claude/CLAUDE.md` (mak:setup picks by the user's language). **Edit both together**; markers must stay identical across the pair
- `README.md` / `docs/guide.md` are Korean with English twins (`README.en.md`, `docs/guide.en.md`) — **edit both sides together**

## Consistency invariants

- Cross-references between skills/agents always use the `mak:` prefix (`mak:dev-kickoff`), never bare names
- Agent availability is phrased as "if the agent is in the available agent list", never as a `.claude/agents/*.md` file-existence check
- The design-doc save-path rule has ONE home: `skills/design-doc-template/SKILL.md` §Save location (default `.claude/mak/plan/`). Everywhere else attributes it to that rule rather than stating it independently
- An agent that loads a companion skill via frontmatter `skills:` must not restate that skill's procedure or report format — point at it instead
- The task grades and the four coding principles have ONE home: `docs/guide.md §2.1 / §2.2`. The setup snippets inject copies of both — a change to either table must be synced across 4 places: guide ko/en + snippet ko/en; skills/agents keep the "project/global Coding Rules take precedence" phrasing
- Frontmatter `description` carries trigger conditions only (loaded into every session); detailed criteria go in the body. Agent descriptions are the exception — the orchestrator selects on that text, so capability/constraint wording stays
- Use `${CLAUDE_PLUGIN_ROOT}` for referencing files inside the plugin
- Adding or removing a skill/agent is a multi-file sync — follow [docs/maintenance.md](docs/maintenance.md) §Adding or Removing a Skill / Agent, which owns the point list. **This file intentionally carries no counts or component lists**, so it stays out of that sync

## Verification

1. `claude plugin validate .`
2. Consistency greps (must be zero hits): `~/.claude/skills` in skills/agents; `.claude/docs` in skills/agents; bare (unprefixed) skill/agent names in skills/agents; Korean residue outside the setup snippet
3. On rule changes: local smoke — `claude plugin marketplace add <repo path>` → `claude plugin install mak@mw-agent-kit` → check skills/agents appear
4. On setup/teardown changes: simulate inject → re-run → remove round-trip against a scratch file
5. On adding/removing/rewiring a skill or agent: `CLAUDE.md` §Verification Commands 3 (graph connectivity — SINK/ORPHAN). This is the only check that catches a component nothing routes into
6. On changes to `skills/reverse-engineering/assets/`: `CLAUDE.md` §Verification Commands 6 (compact-profile closure and `related_to` symmetry)

## Git

Commit/push only when the user explicitly says "commit"/"push".
