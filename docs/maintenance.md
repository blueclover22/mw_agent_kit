# Maintenance — Adding / Removing Components and Releasing

Read this before adding or removing a skill or agent, and before cutting a release.
Language: English (contributor doc, same policy as `CLAUDE.md` / `AGENTS.md`). No Korean twin.

## Adding or Removing a Skill / Agent

The component inventory is mirrored across user-facing docs, so every add/remove is a multi-file sync. Grep alone is not enough: a removal also leaves **inbound** references (routing pointers, handoff lines) that name the component, and an addition is silently dead unless something routes into it.

**Skill** — 6 sync points:

| # | Target | What |
| :-- | :--- | :--- |
| 1 | `skills/<name>/SKILL.md` (+ `assets/` if any) | The skill itself |
| 2 | Handoff wiring | Skills that route into/out of it (§Route to a different skill when, handoff lines). **Skipping this leaves a skill nothing ever invokes** |
| 3 | `skills/setup/assets/claude-md-snippet.ko.md` + `.en.md` | Delegation-rules chain (order·relationships·constraints only — per-skill entry conditions belong in each description) — **edit both** |
| 4 | `README.md` + `README.en.md` | Count in **2 places each** (intro line, `### Skills (N)` heading) + the `/mak:<name>` table row. **Conditional**: if the skill sits on the main development flow, also add it to the §5 ASCII flow diagram — **edit both** and keep the node sets identical to each other and to `docs/guide.md` §3. Flow-external skills (setup/teardown/reverse-engineering) stay out of the diagram |
| 5 | `docs/guide.md` + `docs/guide.en.md` | Count in the `> Scope:` line + the §2 table row (`mak:setup` / `mak:teardown` share one row, so rows = skills − 1) |
| 6 | `.claude-plugin/plugin.json` | Addition → minor; removal → major (§Release) |

**Agent** — same minus the chain position: `agents/<name>.md` → snippet ko/en agent list → README ko/en (**count in the intro line and the `### Agents (N)` heading**, plus the agent table row) → `docs/guide.md` / `.en` (**count in the `> Scope:` line**, plus the §6 table row) → `plugin.json`.

Then run `CLAUDE.md` §Verification Commands plus:

```
ls -d skills/*/ | wc -l                      # must equal every count in 4–5
ls -1 agents/*.md | wc -l                    # must equal every agent count in 4–5
grep -rn "mak:<name>" skills/ agents/ README*.md docs/guide*.md CLAUDE.md
```

The filesystem is the source of truth for the inventory — no file carries a hand-maintained component list except the counts in 4–5, which the two `wc -l` commands above check.

`AGENTS.md` deliberately carries **no counts or component lists** — keep it that way so it never enters this sync set.

## Release

- Bump `version` in `.claude-plugin/plugin.json` (semver, 1.0.0 = first real release). **Bump only when shipped behavior changes** — the install cache is keyed by version, so a bump is exactly what makes an update reach installed users:
  - Major: breaks installed users — skill/agent **removals** or renames, marker-format or snippet-contract changes, save-path default changes
  - Minor: new skills / agents / capabilities
  - Patch: fixes inside existing skills/agents that change what the model does (procedure, gates, rule wording)
  - **No bump**: repo-documentation-only changes (README, docs/guide, contributor docs) — a stale cached copy of these is harmless, and they are read from the repo/GitHub anyway
- Tag the version-bump commit with the matching annotated tag (`git tag -a v1.2.3 -m "mak v1.2.3"`, pushed separately via `git push origin v1.2.3`). Tags do not affect installation — the marketplace always tracks the default branch — but they pin which commit shipped as each version. Before bumping, run `git diff <last tag>..HEAD --stat -- skills/ agents/` to catch behavior changes that accumulated without a bump
- The marketplace name `mw-agent-kit` and plugin name `mak` must not change — this invariant also lives in `CLAUDE.md` §Reference Rules, which is always loaded
- When the `claude-md-snippet.ko.md` / `.en.md` pair changes, confirm the README note "re-run /mak:setup after updates" still holds
