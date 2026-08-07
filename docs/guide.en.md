# mak Usage Guide

> Scope: the `mak` plugin's 12 skills + 5 agents + the common Workflow rules installed by `/mak:setup`
> Purpose: reproduce a consistent "diverge → kickoff/architecture consult → design → verify → review → commit" flow in any project, plus a roadmap axis for project-wide direction
>
> 한국어 버전: [guide.md](guide.md)

---

## 1. Purpose of the Kit

**A development-process skill set (diverge → kickoff/consult → design → verify → review → commit) + a top-level roadmap axis + coding principles (§Coding Rules)**

The kit packages the core stages that repeat in every project — idea divergence → kickoff/convergence → architecture consultation when needed → design documentation → implementation verification → review reporting → wrap-up commit — into reusable skills with consistent procedures and formats. On top, `mak:roadmap-planning` handles mid/long-term direction across phases as a separate axis.

- No dependency on a specific language, framework, or build tool
- With the agents (mak:planner/coder/reviewer/doc-editor/analyzer) available, skills are used through delegation; where delegation isn't possible, the skills alone reproduce the same flow
- The coding principles (think before coding / simplicity first / precise changes / goal-driven execution) are defined in §2.2 of this guide and enforced inside skills as self-checks and gates. If you define your own §Coding Rules in the global/project CLAUDE.md, those take precedence
- `/mak:setup` installs the Workflow task grades, the coding-principle mapping (a copy of §2.2), and the mak delegation summary as a marker block in `~/.claude/CLAUDE.md` (personal rules are never touched)

## 2. Skill Overview

| Skill | One-liner |
| :--- | :--- |
| `mak:roadmap-planning` | Establish/maintain the project-wide phase structure. Mid/long-term direction, priorities, status. No implementation (HARD-GATE) |
| `mak:brainstorming` | Divergence-only stage for vague/multi-directional requirements. Simplicity is an evaluation axis; "simpler alternative" check enforced. No implementation or design docs (HARD-GATE) |
| `mak:dev-kickoff` | Kickoff sizing + conversational orchestration for Non-trivial/Risky work. Requirements convergence → planner consult decision → options → verifiable goals → approval gate → documentation handoff. No implementation before approval (HARD-GATE) |
| `mak:design-doc-template` | Design-doc sections §1–§8, §5.0 Step → verify table, option comparison, assumption notation, quality checklist, and the **save-location rule SSOT (default `.claude/mak/plan/`)** |
| `mak:major-feature-pack` | Structured 9-doc pack for large features/ports whose upfront analysis must be split across documents. `mig_`/`feat_` prefixes, cross-reference conventions, intentional-deviation tables. Judged by analysis breadth, not PR/module count (§4) |
| `mak:verify-checklist` | Post-implementation order: build → lint → tests → format (changed files only) → manual scenarios. Pre-report self-check + "predefined criteria vs results" table |
| `mak:review-report` | SSOT for the review procedure and report format. 🔴 Critical / 🟡 Warning / 🟢 Pass / 📝 Note, 6-item Warning checklist |
| `mak:doc-audit` | Doc-to-doc consistency audit + verification of code paths/symbols cited in documents. `mak:review-report` audits one design against implementation; `mak:doc-audit` checks whether other docs citing that slice remain valid — the gap. Triggered after slice/phase completion, at phase transitions, or before handing off an unfinished session. Reports only; never edits documents |
| `mak:commit` | Work wrap-up commit. Pre-commit gates (verification confirmed, every changed line ties to the request, junk/secret scan) → commit with a message matching the repo's convention → at-a-glance result report. Invoking the skill counts as the explicit commit request; other git ops (push/amend/rebase, …) run only on the user's explicit request |
| `mak:setup` / `mak:teardown` | Install / remove the common rules as a marker block in `~/.claude/CLAUDE.md` |
| `mak:reverse-engineering` | Copy the standard doc set (14 docs + domains/) into the project's `docs/` and fill it via code analysis |

> Each skill carries "route to a different skill when" pointers at the top, so a wrong pick self-corrects mid-procedure.

### 2.1 Task Grades

Classify work by size and risk first. The grade decides whether `mak:dev-kickoff` and `mak:planner` are used.

| Grade | Criteria | Default flow |
| :--- | :--- | :--- |
| **Trivial** | Typos, formatting, comments, one-liners, obvious independent single-file fixes | Read the existing file and fix directly — no design doc or approval gate. Use `mak:coder` if desired |
| **Small** | Small-impact, easily reversible bug fixes / minor behavior changes | Share brief change intent + verification method, then proceed. Usually skip `mak:dev-kickoff` (keep bug reproduction/verification) |
| **Non-trivial** | Multiple files/modules, new features/components, structural choices | Enter via `mak:dev-kickoff`. Request a `mak:planner` Architecture Brief when the structure is complex or options genuinely diverge |
| **Risky** | Data model, dependencies, security, deployment, migration, multi-module impact | `mak:dev-kickoff` + `mak:planner` Architecture Brief as a rule |

### 2.2 Coding-Principle Mapping (SSOT for the kit's coding principles)

| Principle | Core behaviors | Enforcement gates |
| :--- | :--- | :--- |
| **Think before coding** | Mark assumptions; present all interpretations; propose/push back with simpler alternatives; stop and ask when confused | mak:brainstorming §3·§5, mak:dev-kickoff §2·§3·§4, mak:planner Brief, mak:design-doc-template §Quality Checklist |
| **Simplicity first** | No unrequested features, speculative flexibility, impossible-scenario handling; include simpler alternatives | mak:dev-kickoff §3·§4·§8, mak:planner Brief, mak:design-doc-template §Quality Checklist, mak:verify-checklist §Self-Check, mak:review-report §Warning |
| **Precise changes** | No out-of-scope files; single purpose per change; no adjacent "improvements"; match existing style; every changed line ties to the request | mak:dev-kickoff §8, mak:verify-checklist §Self-Check, mak:review-report §Warning, mak:coder agent |
| **Goal-driven execution** | Convert to verifiable goals; `Step → verify: check` plans; verify after changes; confirm behavior before reporting | mak:dev-kickoff §5, mak:design-doc-template §5.0, mak:verify-checklist §Report Format |

> Source: these four principles are adapted from — and inspired by — the AI-coding guidelines shared by Andrej Karpathy.

## 3. `mak:roadmap-planning` — the Roadmap Axis

Operates as a **separate, higher axis** above the 6-stage flow. Shape the project-wide direction (phases) first; apply the 6-stage flow at each phase's kickoff.

```
mak:roadmap-planning (once at project start + periodic updates)
      │  pick a phase
      ▼
[opt] mak:brainstorming → mak:dev-kickoff → [mak:planner Brief if needed]
      → mak:design-doc-template → implement → mak:verify-checklist → mak:review-report → mak:commit
```

## 4. Scenario Flows (single feature vs. large feature)

Branch on **whether the upfront analysis fits one document** — into the single design-doc flow or the 9-doc pack flow (analysis breadth, not PR/module count).

```
Requirements received
      │
      ▼
[opt] ① mak:brainstorming — only when vague / multi-directional
      │ direction chosen
      ▼
   ┌──────────────────────────────┬────────────────────────────────────┐
   │ single concern (one doc)     │ split analysis / cross-stack port  │
   ▼                              ▼
② mak:dev-kickoff →            ②' mak:major-feature-pack
   [planner Brief if needed]      (9 docs: 02→01→03→04→05→06→07→08→00)
③ mak:design-doc-template          │ repeat ②–⑥ per PR step of §08
                                    │ (9-doc pack stays the SSOT)
   │                                │
   └──────────┬─────────────────────┘
              ▼
      ④ implement → mak:verify-checklist
              ▼
      ⑤ mak:review-report (fixes → re-delegate to ④; reviewer never edits)
              ▼
      ⑥ (wrap-up) mak:commit — commit after gates (push etc. only on explicit request)
```

Decision criteria:

| Signal | design-doc-template | major-feature-pack |
| :--- | :--- | :--- |
| **Need to split upfront analysis** (key) | Fits one document | Current state, spec gaps, policy, data, contracts need separate tracking |
| External/legacy system alignment | None or local | Required (current vs spec + intentional-deviation matrix) |
| External policy/security decisions | None or one | Many (TBDs arise) |
| Cross-stack port | — | Applies |
| Data-model change | Single type | Matrix-scale |

> **Multi-PR / multi-module is not the criterion.** Single-concern multi-PR work (e.g. structural refactor) uses `mak:design-doc-template`'s **master doc (decisions, PR dependency graph) + per-PR sub-docs**.

## 5. Install and Apply

**When running in the terminal:**

```bash
claude plugin marketplace add blueclover22/mw_agent_kit   # once
claude plugin install mak@mw-agent-kit
```

**When running inside a Claude Code session** (built-in command — no model, no tokens):

```
/plugin marketplace add blueclover22/mw_agent_kit
/plugin install mak@mw-agent-kit
```

| Step | Command/action | Effect |
| :--- | :--- | :--- |
| Install common rules (once) | `/mak:setup` | Adds the Workflow task grades + coding-principle mapping + mak delegation summary marker block to `~/.claude/CLAUDE.md`. Re-running updates only the block; personal rules untouched |
| Project doc set (optional) | `/mak:reverse-engineering` | Copies the standard doc set to `docs/` and fills it via analysis (compact/standard profile) |
| Project-specific rules (recommended) | Write `<project>/.claude/CLAUDE.md` | Verification commands, doc paths, domain rules. Skills consult this file first |
| Remove | `/mak:teardown` → `claude plugin uninstall` | Restore the marker block, then uninstall |

The default design-doc path is `.claude/mak/plan/`; a path specified in the project `.claude/CLAUDE.md` wins (`mak:design-doc-template` §Save location is the SSOT).

> Mechanical enforcement (secret-file read-deny, verification-command allowlists, hooks) varies per project/user and is not shipped in the plugin. Configure it yourself in `~/.claude/settings.json` / `<project>/.claude/settings.json` if needed. **Agent constraints like "documents only" / "never modifies code" are prompt-level rules** — tool lists narrow the surface, but they don't technically prevent mistakes or prompt injection; on sensitive codebases, back them with permission settings, sandboxing, and command allowlists.

## 6. Relationship with the Agents

| Situation | Behavior |
| :--- | :--- |
| `mak:planner` available | For Non-trivial/Risky work the main thread hands over scope and requests an Architecture Brief. Planner reports options/recommendation/risks/decisions-needed; after decisions are confirmed it writes the design doc once. It never questions the user or finalizes decisions |
| `mak:coder` available | Implementation delegated after design approval. Trivial/Small may skip the design doc on explicit request. In 9-doc packs, `08-implementation-plan.md`'s PR steps are the scope SSOT |
| `mak:reviewer` available | Review delegated on stage completion. Reports only; never edits code |
| `mak:doc-editor` available | Doc sync delegated after feature completion |
| `mak:analyzer` available | The analysis/doc-filling stage of `mak:reverse-engineering` delegated in batches. Records facts (is) only; never modifies code. Interactive decisions (profile, overwrites) and cross-document syncs stay with the main thread |
| Delegation unavailable | The main thread runs the skill's procedure directly — the in-skill self-check gates enforce the coding principles (§2.2) |

**Delegation principles**: stages requiring conversation (requirements convergence, option approval, design gates) stay in the main thread (subagents can't talk to the user). Never invoke `mak:coder` without an approved plan. `mak:reviewer` is not proactively auto-invoked.

## 7. Template Customization

Installed plugin files can't be edited in place. Fork the repository, modify the following, and distribute via your own marketplace.

| File | Customization examples |
| :--- | :--- |
| `skills/design-doc-template/assets/design-doc.template.md` | Project-specific sections (DB schema, API spec) |
| `skills/review-report/assets/review-report.template.md` | Team-specific grades / required checks |
| `skills/roadmap-planning/assets/roadmap.template.md` | Phase count, status icons, naming |
| `skills/reverse-engineering/assets/project_docs/` | Doc-set composition, stack mappings |
| `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` | The injected common rules themselves (ko/en mirrors — edit together) |

Keep the `{{placeholder}}` structure when editing templates so skills recognize where to fill.

## 8. Operating Tips (light mode, observation, regression)

- **Use only what you need** — for Trivial/Small-heavy projects start with `mak:verify-checklist` alone and escalate to dev-kickoff → planner/reviewer as needed. Start the doc set on the compact profile.
- **Observation** — make the pre-report self-check (verify-checklist) a habit: every changed line tied to the request? no out-of-scope edits? verification actually run?
- **Regression check** — after modifying skills/rules in a fork, manually walk two scenarios: ① Trivial work isn't blocked by gates; ② a Non-trivial feature honors "no implementation before approval / planner advises only / doc written once / reviewer never edits".
- **Memory** — accumulate recurring corrections/preferences/decisions in the project `CLAUDE.md` / `docs/` / Claude Code memory as appropriate.
