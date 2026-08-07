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

- 11 skills: brainstorming / dev-kickoff / design-doc-template / roadmap-planning / verify-checklist / review-report / doc-audit / commit / setup / teardown / reverse-engineering
- 5 agents: planner(opus) / coder(sonnet) / reviewer(opus) / doc-editor(haiku) / analyzer(opus) — coder/reviewer/planner load their companion skill via frontmatter `skills:`; analyzer follows the copied doc set's own rulebook (target `docs/CLAUDE.md`·`00.INDEX.md`) instead

## Adding or Removing a Skill / Agent

The inventory above is mirrored across user-facing docs, so every add/remove is a multi-file sync. Grep alone is not enough: a removal also leaves **inbound** references (routing pointers, handoff lines) that name the component, and an addition is silently dead unless something routes into it.

**Skill** — 7 sync points:

| # | Target | What |
| :-- | :--- | :--- |
| 1 | `skills/<name>/SKILL.md` (+ `assets/` if any) | The skill itself |
| 2 | Handoff wiring | Skills that route into/out of it (§Route to a different skill when, handoff lines). **Skipping this leaves a skill nothing ever invokes** |
| 3 | `skills/setup/assets/claude-md-snippet.ko.md` + `.en.md` | Delegation-summary chain — **edit both** |
| 4 | `README.md` + `README.en.md` | Count in **2 places each** (intro line, `### Skills (N)` heading) + the `/mak:<name>` table row |
| 5 | `docs/guide.md` + `docs/guide.en.md` | Count in the `> Scope:` line + the §2 table row (`mak:setup` / `mak:teardown` share one row, so rows = skills − 1) |
| 6 | `CLAUDE.md` §Components | Count + the slash-separated list |
| 7 | `.claude-plugin/plugin.json` | Addition → minor; removal → major (§Release) |

**Agent** — same minus the chain position: `agents/<name>.md` → snippet ko/en agent list → README ko/en agent table → `docs/guide.md` / `.en` §6 table → `CLAUDE.md` §Components → `plugin.json`.

Then run §Verification Commands plus:

```
ls -d skills/*/ | wc -l                      # must equal every count in 4–6
grep -rn "mak:<name>" skills/ agents/ README*.md docs/guide*.md CLAUDE.md
```

`AGENTS.md` deliberately carries **no counts or component lists** — keep it that way so it never enters this sync set.

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
- Tag the version-bump commit with the matching annotated tag (`git tag -a v1.2.3 -m "mak v1.2.3"`, pushed separately via `git push origin v1.2.3`). Tags do not affect installation — the marketplace always tracks the default branch — but they pin which commit shipped as each version. Before bumping, run `git diff <last tag>..HEAD --stat -- skills/ agents/` to catch behavior changes that accumulated without a bump
- The marketplace name `mw-agent-kit` and plugin name `mak` must not change (installed users' references would break)
- When the `claude-md-snippet.ko.md` / `.en.md` pair changes, confirm the README note "re-run /mak:setup after updates" still holds
