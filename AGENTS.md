# AGENTS.md — Working on the mak Plugin Repository

This repository IS the Claude Code plugin `mak` (repo root = plugin root; manifest at `.claude-plugin/plugin.json`). Everything is Markdown / JSON — no build, no tests.

Full development rules live in [CLAUDE.md](CLAUDE.md). The invariants below are the ones you must not break:

## Language policy

- `skills/*/SKILL.md` and `agents/*.md` instructions/descriptions: **English**
- `skills/*/assets/` templates and doc sets: **English** (output language is delegated to "follow the user's language" notes in skills)
  - **Exception**: `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` — a **Korean/English mirror pair** injected verbatim into `~/.claude/CLAUDE.md` (mak:setup picks by the user's language). **Edit both together**; markers must stay identical across the pair
- `README.md` / `docs/guide.md` are Korean with English twins (`README.en.md`, `docs/guide.en.md`) — **edit both sides together**

## Consistency invariants

- Cross-references between skills/agents always use the `mak:` prefix (`mak:dev-kickoff`), never bare names
- Agent availability is phrased as "if the agent is in the available agent list", never as a `.claude/agents/*.md` file-existence check
- The design-doc save-path rule has ONE home: `skills/design-doc-template/SKILL.md` §Save location (default `.claude/mak/plan/`). Everywhere else references that rule instead of hardcoding paths
- The review procedure/report format has ONE home: `skills/review-report/SKILL.md`; `agents/reviewer.md` must not duplicate it
- The task grades and the four coding principles have ONE home: `docs/guide.md §2.1 / §2.2`. The setup snippets inject copies of both — a change to either table must be synced across 4 places: guide ko/en + snippet ko/en; skills/agents keep the "project/global Coding Rules take precedence" phrasing
- Frontmatter `description` carries trigger conditions only (loaded into every session); detailed criteria go in the body
- Use `${CLAUDE_PLUGIN_ROOT}` for referencing files inside the plugin
- Adding or removing a skill/agent is a 7-point sync (handoff wiring, setup snippets ko/en, README ko/en, guide ko/en, `CLAUDE.md` §Components, `plugin.json`) — follow [CLAUDE.md](CLAUDE.md) §Adding or Removing a Skill / Agent. **This file intentionally carries no counts or component lists**, so it stays out of that sync

## Verification

1. `claude plugin validate .`
2. Consistency greps (must be zero hits): `~/.claude/skills` in skills/agents; `.claude/docs` in skills/agents; bare (unprefixed) kit-skill names in skills/agents
3. On rule changes: local smoke — `claude plugin marketplace add <repo path>` → `claude plugin install mak@mw-agent-kit` → check skills/agents appear
4. On setup/teardown changes: simulate inject → re-run → remove round-trip against a scratch file

## Git

Commit/push only when the user explicitly says "commit"/"push".
