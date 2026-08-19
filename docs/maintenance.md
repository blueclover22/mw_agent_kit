# Maintenance — Adding / Removing Components, Conditional Verification, and Releasing

Read this before adding or removing a skill or agent, before cutting a release, and whenever one of the conditional verification triggers in `CLAUDE.md` fires.
Language: English (contributor doc, same policy as `CLAUDE.md` / `AGENTS.md`). No Korean twin.

## Adding or Removing a Skill / Agent

The component inventory is mirrored across user-facing docs, so every add/remove is a multi-file sync. Grep alone is not enough: a removal also leaves **inbound** references (routing pointers, handoff lines) that name the component, and an addition is silently dead unless something routes into it.

**Skill** — 6 sync points:

| # | Target | What |
| :-- | :--- | :--- |
| 1 | `skills/<name>/SKILL.md` (+ `assets/` if any) | The skill itself |
| 2 | Handoff wiring | Skills that route into/out of it (§Route to a different skill when, handoff lines). **Skipping this leaves a skill nothing ever invokes** |
| 3 | `skills/setup/assets/claude-md-snippet.ko.md` + `.en.md` | Delegation-rules chain (order·relationships·constraints) **and the request-type → entry-point routing table**, whose rows name the entry skills — detailed per-skill criteria still belong in each description — **edit both** |
| 4 | `README.md` + `README.en.md` | Count in **2 places each** (intro line, `### Skills (N)` heading) + the `/mak:<name>` table row. **Conditional**: if the skill sits on the main development flow, also add it to the §5 ASCII flow diagram — **edit both** and keep the node sets identical to each other and to `docs/guide.md` §3. Flow-external skills (setup/teardown/reverse-engineering) stay out of the diagram |
| 5 | `docs/guide.md` + `docs/guide.en.md` | Count in the `> Scope:` line + the §2 table row (`mak:setup` / `mak:teardown` share one row, so rows = skills − 1) |
| 6 | `.claude-plugin/plugin.json` | Addition → minor; removal → major (§Release) |

**Agent** — same 6 points, and #4's ASCII flow diagram does apply: agents appear there not as numbered nodes but as `▶ delegate` annotations on the stage that delegates to them (see the `▶` legend). An agent on the main cycle must be added to or removed from all four diagrams (README ko/en + guide ko/en) together. Sync points: `agents/<name>.md` → **handoff wiring** (see below) → snippet ko/en agent list (**and the routing table row, if the agent appears there**) → README ko/en (**count in the intro line and the `### Agents (N)` heading**, plus the agent table row) → `docs/guide.md` / `.en` (**count in the `> Scope:` line**, plus the §6 table row) → `plugin.json` **and `.claude-plugin/marketplace.json`** (both descriptions enumerate the agents, so both drift when one is edited alone).

Handoff wiring applies to agents exactly as it does to skills — the connectivity check in §Conditional Verification below runs `for f in skills/*/SKILL.md agents/*.md`, so a new agent that nothing mentions is an ORPHAN and one that mentions nobody is a SINK. The check sees mentions, not real handoffs — read the wiring yourself. Give every added agent at least one inbound reference from the skill or agent that delegates to it, and at least one outbound reference for where its findings go.

Then run `CLAUDE.md` §Verification Commands 1–2, the graph-connectivity check in §Conditional Verification below, plus:

```
ls -d skills/*/ | wc -l                      # must equal every count in 4–5
ls -1 agents/*.md | wc -l                    # must equal every agent count in 4–5
grep -rn "mak:<name>" skills/ agents/ README*.md docs/guide*.md CLAUDE.md
```

The filesystem is the source of truth for the inventory — no file carries a hand-maintained component list except the counts in 4–5, which the two `wc -l` commands above check.

`AGENTS.md` deliberately carries **no counts or component lists** — keep it that way so it never enters this sync set.

## Conditional Verification

Run after every change: `CLAUDE.md` §Verification Commands 1–2. The procedures below are conditional — `CLAUDE.md` carries their triggers, this file carries the commands.

### Graph connectivity — a skill/agent was added, removed, or rewired

The sync points above check *counts*; this checks *wiring*, which counts cannot catch:

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

`commit` is the **one intended orphan** — a user gate entered only on explicit request, so nothing routes into it. Any other name in either list is a wiring bug: a skill nothing ever invokes, or a stage that dead-ends. The `Never route into` filter is why the negative-edge wording in `CLAUDE.md` §Reference Rules is mandatory — without it a prohibition counts as an inbound edge and hides an orphan.

**What this check cannot see** — it detects *mention*, not *handoff*. A `mak:<name>` reference may be a real transition (a §Handoff section, `dev-kickoff` §10) or merely routing advice (§Route to a different skill when, §When to Use exclusions), and grep cannot separate them. Consequences: a skill that only says "not my job" about other skills passes the SINK check while handing work to no one, and cycle counts are inflated by mutual advice — most three-cycles in this graph are advice loops, not work loops (the real ones run through `coder → verify-checklist → review-report`/`reviewer → coder`). So read any new or changed §Handoff section yourself: the check catches **missing** wiring, never **wrong** wiring.

### Local smoke — `skills/` · `agents/` · manifest changed (what actually ships)

`claude plugin marketplace add <repo path>` → `claude plugin install mak@mw-agent-kit` → check skills/agents appear. Note: with a same-version local marketplace, `plugin update` does NOT refresh the cache — bump `version` in plugin.json or uninstall/reinstall

### setup/teardown round-trip — inject/remove logic changed

Simulate the inject → re-run (block replaced, no duplication) → remove round-trip against a scratch file

### Compact-profile closure — `skills/reverse-engineering/assets/` changed

The compact profile (`00 02 03 04 06 09 10 13` + `README.template.md`) must stay closed — filename references to `01`/`05`/`07`/`08`/`11`/`12` outside a `standard-only`-tagged line, and `related_to` asymmetry inside that set (00 hub / 13 one-way excepted), must both be zero hits:

```
grep -n '01\.Glossary\.md\|05\.framework-api\.md\|07\.backend-guide\.md\|08\.domains\.md\|11\.test-guide\.md\|12\.process-guide\.md' skills/reverse-engineering/assets/project_docs/{00.INDEX,02.architecture,03.coding-rules,04.framework-guide,06.frontend-guide,09.project-guide,10.build-ops-guide,13.roadmap}.md skills/reverse-engineering/assets/README.template.md | grep -v standard-only
fm() { awk 'NR>1 && /^---$/{exit} {print}' "$1"; }; D=skills/reverse-engineering/assets/project_docs; for f in $D/{02.architecture,03.coding-rules,04.framework-guide,06.frontend-guide,09.project-guide,10.build-ops-guide}.md; do b=$(basename "$f"); for t in $(fm "$f" | grep -v standard-only | grep -oE '[0-9]{2}\.[A-Za-z.-]+\.md'); do fm "$D/$t" 2>/dev/null | grep -q "\"$b\"" || echo "ASYMMETRY: $b -> $t"; done; done
```

## Release

- Bump `version` in `.claude-plugin/plugin.json` (semver, 1.0.0 = first real release). **Bump only when shipped behavior changes** — the install cache is keyed by version, so a bump is exactly what makes an update reach installed users:
  - Major: breaks installed users — skill/agent **removals** or renames, marker-format or snippet-contract changes, save-path default changes
  - Minor: new skills / agents / capabilities
  - Patch: fixes inside existing skills/agents that change what the model does (procedure, gates, rule wording)
  - **No bump**: repo-documentation-only changes (README, docs/guide, contributor docs) — a stale cached copy of these is harmless, and they are read from the repo/GitHub anyway
- Tag the version-bump commit with the matching annotated tag (`git tag -a v1.2.3 -m "mak v1.2.3"`, pushed separately via `git push origin v1.2.3`). Tags do not affect installation — the marketplace always tracks the default branch — but they pin which commit shipped as each version. Before bumping, run `git diff <last tag>..HEAD --stat -- skills/ agents/` to catch behavior changes that accumulated without a bump
- The marketplace name `mw-agent-kit` and plugin name `mak` must not change — this invariant also lives in `CLAUDE.md` §Reference Rules, which is always loaded
- When the `claude-md-snippet.ko.md` / `.en.md` pair changes, confirm the README note "re-run /mak:setup after updates" still holds
