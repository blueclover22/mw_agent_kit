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
- A reference that **forbids** routing to a component (rather than pointing at it) must be phrased `Never route into \`mak:<name>\`` — the fixed wording is what lets the connectivity check below tell a prohibition apart from a real handoff. Both read as `mak:<name>` to grep, so an unmarked prohibition silently counts as an inbound edge and hides an orphan. Currently the only one is `skills/verify-checklist/SKILL.md` → `mak:commit`
- `agents/coder.md`, `agents/reviewer.md`, `agents/auditor.md` load their companion skill via frontmatter `skills:`; `agents/analyzer.md` must NOT — it follows the copied doc set's own rulebook (target `docs/CLAUDE.md`·`00.INDEX.md`) instead
- The marketplace name `mw-agent-kit` and the plugin name `mak` must never change — installed users' references would break

## Maintenance Procedures

- Adding or removing a skill / agent, and cutting a release: read `docs/maintenance.md` first — both are multi-file syncs

## Verification Commands

This is a Markdown/JSON repository — no build or tests. After changes, run:

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
3. Graph connectivity — run whenever a skill/agent is added, removed, or rewired. The `docs/maintenance.md` sync points check *counts*; this checks *wiring*, which counts cannot catch:

   ```
   for f in skills/*/SKILL.md agents/*.md; do
     n=$(basename $(dirname "$f")); [ "$n" = agents ] && n=$(basename "$f" .md)
     grep -v 'Never route into' "$f" | grep -o 'mak:[a-z-]*' | sed "s|^|$n |"
   done | grep -v 'mak:begin\|mak:end' \
     | awk '{split($2,a,":"); if(a[2]!=$1) print $1, a[2]}' | sort -u > /tmp/mak-edges.txt

   # SINK — no outbound edge: the stage does not know where work goes next. Must print nothing
   for f in skills/*/SKILL.md agents/*.md; do n=$(basename $(dirname "$f")); [ "$n" = agents ] && n=$(basename "$f" .md); grep -q "^$n " /tmp/mak-edges.txt || echo "SINK: $n"; done

   # ORPHAN — nothing routes in. Must print `commit` and nothing else
   for f in skills/*/SKILL.md agents/*.md; do n=$(basename $(dirname "$f")); [ "$n" = agents ] && n=$(basename "$f" .md); grep -q " $n\$" /tmp/mak-edges.txt || echo "ORPHAN: $n"; done
   ```

   `commit` is the **one intended orphan** — a user gate entered only on explicit request, so nothing routes into it. Any other name in either list is a wiring bug: a skill nothing ever invokes, or a stage that dead-ends. The `Never route into` filter is why the negative-edge wording in §Reference Rules is mandatory — without it a prohibition counts as an inbound edge and hides an orphan.

   **What this check cannot see** — it detects *mention*, not *handoff*. A `mak:<name>` reference may be a real transition (a §Handoff section, `dev-kickoff` §10) or merely routing advice (§Route to a different skill when, §When to Use exclusions), and grep cannot separate them. Consequences: a skill that only says "not my job" about other skills passes the SINK check while handing work to no one, and cycle counts are inflated by mutual advice — most three-cycles in this graph are advice loops, not work loops (the real ones run through `coder → verify-checklist → review-report`/`reviewer → coder`). So read any new or changed §Handoff section yourself: the check catches **missing** wiring, never **wrong** wiring.
4. Local smoke (on rule changes): `claude plugin marketplace add <repo path>` → `claude plugin install mak@mw-agent-kit` → check skills/agents appear. Note: with a same-version local marketplace, `plugin update` does NOT refresh the cache — bump `version` in plugin.json or uninstall/reinstall
5. On setup/teardown logic changes: simulate the inject → re-run (block replaced, no duplication) → remove round-trip against a scratch file
6. On changes to `skills/reverse-engineering/assets/`: the compact profile (`00 02 03 04 06 09 10 13` + `README.template.md`) must stay closed — filename references to `01`/`05`/`07`/`08`/`11`/`12` outside a `standard-only`-tagged line, and `related_to` asymmetry inside that set (00 hub / 13 one-way excepted), must both be zero hits:

   ```
   grep -n '01\.Glossary\.md\|05\.framework-api\.md\|07\.backend-guide\.md\|08\.domains\.md\|11\.test-guide\.md\|12\.process-guide\.md' skills/reverse-engineering/assets/project_docs/{00.INDEX,02.architecture,03.coding-rules,04.framework-guide,06.frontend-guide,09.project-guide,10.build-ops-guide,13.roadmap}.md skills/reverse-engineering/assets/README.template.md | grep -v standard-only
   fm() { awk 'NR>1 && /^---$/{exit} {print}' "$1"; }; D=skills/reverse-engineering/assets/project_docs; for f in $D/{02.architecture,03.coding-rules,04.framework-guide,06.frontend-guide,09.project-guide,10.build-ops-guide}.md; do b=$(basename "$f"); for t in $(fm "$f" | grep -v standard-only | grep -oE '[0-9]{2}\.[A-Za-z.-]+\.md'); do fm "$D/$t" 2>/dev/null | grep -q "\"$b\"" || echo "ASYMMETRY: $b -> $t"; done; done
   ```

## Document Paths

- Design docs for this repository: `.claude/mak/plan/` (working documents; may be removed once their work is finished)
