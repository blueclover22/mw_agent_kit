# mak — MW Agent Kit

> A development-process plugin for Claude Code — provides the diverge → kickoff → design → implement → verify → review → commit flow as skills and agents.
>
> 한국어 버전: [README.md](README.md)

`mak` is a Claude Code plugin for reproducing the same development process in any language/stack. It ships 12 skills and 6 agents, with no dependency on a specific framework or build tool.

---

## 1. Install

**When running in the terminal:**

```bash
# 1. Register the marketplace (once)
claude plugin marketplace add blueclover22/mw_agent_kit
#    (from a local checkout: claude plugin marketplace add /path/to/mw_agent_kit)

# 2. Install the plugin
claude plugin install mak@mw-agent-kit
```

**When running inside a Claude Code session** (built-in command — no model, no tokens):

```
/plugin marketplace add blueclover22/mw_agent_kit
/plugin install mak@mw-agent-kit
```

> Avoid typing `claude plugin ...` as a natural-language prompt in a session — the model runs it for you and burns tokens; always use the `/plugin` built-in in-session.

Then, **inside a Claude Code session**, install the common rules once:

```
/mak:setup
```

This adds the Workflow task grades, the coding-principle mapping, and the mak delegation rules to `~/.claude/CLAUDE.md` as a marker block (`<!-- mak:begin -->` … `<!-- mak:end -->`). The rules are installed **in your conversation language** (Korean/English, auto-detected; override with `/mak:setup ko` or `/mak:setup en`). Re-running updates only the block; content outside the markers (your personal rules) is never touched.

## 2. Update

**When running in the terminal:**

```bash
claude plugin update mak@mw-agent-kit
```

**When running inside a Claude Code session:** `/plugin` panel → update from the Installed tab

If the update changed the rules (snippet), re-run `/mak:setup` to refresh the block.

> A local-path marketplace does not refresh the cache when the version number is unchanged — during development, reinstall (uninstall → install) instead.

## 3. Uninstall

Before uninstalling, **remove the rules block first** (plugins have no uninstall hook). Inside a Claude Code session:

```
/mak:teardown
```

Then uninstall the plugin.

**When running in the terminal:**

```bash
claude plugin uninstall mak@mw-agent-kit
```

**When running inside a Claude Code session:**

```
/plugin uninstall mak@mw-agent-kit
```

## 4. What's Included

### Skills (12)

| Skill | Role |
| :--- | :--- |
| `/mak:brainstorming` | Idea divergence when requirements are vague (no-implementation gate) |
| `/mak:dev-kickoff` | Kickoff for non-trivial work — requirements convergence, options, approval gate |
| `/mak:dev-resume` | Re-entry point that derives the next task from documents, with evidence, when it isn't decided yet (read/report only) |
| `/mak:design-doc-template` | Design-doc format, save-location rule (SSOT), skeleton |
| `/mak:roadmap-planning` | Project-wide phase structure and status tracking (top-level axis) |
| `/mak:verify-checklist` | Post-implementation order: build → lint → tests → format → manual |
| `/mak:review-report` | Review procedure and report format (Critical/Warning/Pass/Note) |
| `/mak:doc-audit` | Doc-to-doc consistency audit + verification of code paths/symbols cited in documents |
| `/mak:commit` | Work wrap-up commit — gates, commit, at-a-glance result report. Other git ops (push, …) only on explicit request |
| `/mak:setup` | Install the common rules (workflow grades, principle mapping, delegation rules) into `~/.claude/CLAUDE.md` as a marker block |
| `/mak:teardown` | Remove the installed marker block (run before uninstalling) |
| `/mak:reverse-engineering` | Copy the doc set (8 docs compact by default, 14 docs standard) and reverse-engineer the project |

### Agents (6)

| Agent | Model | Role |
| :--- | :--- | :--- |
| `mak:planner` | opus | Non-interactive architecture consultation (Architecture Brief), read-only |
| `mak:coder` | sonnet | Implementation against an approved design |
| `mak:reviewer` | opus | Review and report only (never modifies code) |
| `mak:doc-editor` | haiku | Editing/syncing existing Markdown documents |
| `mak:analyzer` | opus | Code analysis and doc filling — records facts only (never modifies code) |
| `mak:auditor` | opus | `mak:doc-audit` cross-document consistency audit — report-only (never modifies documents) |

## 5. Usage & Documentation

The basic development flow:

```
[higher axis] /mak:roadmap-planning ── shape the phases first; enter the cycle per phase
[resume]      /mak:dev-resume ─────── when the next task itself is undecided (resume / handoff)
   │ task decided
   ▼
[opt] ① /mak:brainstorming ───── only when vague / multi-directional
   │ direction chosen
   ▼
   ② /mak:dev-kickoff ─────────▶ [delegate, opt] mak:planner — Architecture Brief, read-only
   │ ⚑ Approval gate 1 — design content. No file is written before this
   ▼
   ③ /mak:design-doc-template ── design doc = the state between stages
   │ ⚑ Approval gate 2 — start      §5.0 Step table records progress (⬜ / ▶ / ✅)
   ▼
   ④ implement → /mak:verify-checklist ──▶ [delegate] mak:coder
   ▲        build→lint→test→format→manual      advances §5.0 Status per passing step
   │            │
   │            ▼
   │        ⑤ /mak:review-report ──────▶ [delegate] mak:reviewer — reports only, never edits
   └────────────┤ fixes needed → the main thread re-delegates to ④
                ┊ not chained automatically — only on the user's explicit request
                ▼
                ⑥ /mak:commit ── commit after the gates
                   other git ops each need their own explicit request

[outside the cycle] /mak:doc-audit ─▶ [delegate] mak:auditor — reports only, never edits
                    after a slice/phase, at a phase transition, or before handoff
```

- Symbols: `▼ │` default progression · `▶` agent delegation · `┊` a user gate that never advances on its own · `⚑` approval gate · `▲ └─` rework loop
- The arrows are **routing hints the main thread consults**, not an execution path that advances on its own. Skills and agents never invoke each other directly; the main thread always decides the transition ([details](docs/guide.en.md#what-the-arrows-mean--routing-hints-not-guaranteed-execution))
- What persists between stages is the **③ design doc**, not the conversation — when a session ends, only what the documents recorded survives

- The slash menu may show skills without the `mak:` prefix (older Claude Code display behavior). Regardless of display, both `/mak:brainstorming` (canonical) and `/brainstorming` (shorthand) work; if another skill claims the same name, only the prefixed form remains valid.
- Obvious Trivial / Small work (typos, one-liners) skips the process entirely.
- Design docs are saved under the project's `.claude/mak/plan/` by default.
- Picking up a handed-off session, or unsure what to work on next? Start with `/mak:dev-resume` — it derives progress, problems, and next-step candidates from the documents.
- To analyze and document an existing project, use `/mak:reverse-engineering`.

For the full process, task grades, decision criteria, and agent delegation principles, the **usage guide** is the single entry point:

| Document | Location |
| :--- | :--- |
| **Usage guide** (process detail) | [docs/guide.en.md](docs/guide.en.md) · [docs/guide.md](docs/guide.md) |
| Plugin development rules (for contributors) | [CLAUDE.md](CLAUDE.md) · [AGENTS.md](AGENTS.md) |

## 6. Customizing

Installed plugin files can't be edited in place. To adapt the kit, fork the repository, edit the skill `assets/` templates (design doc, review report, roadmap, doc set) and `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` (injected rules, ko/en mirrors), and distribute via your own marketplace.

## 7. License / Acknowledgements

- [MIT License](LICENSE)
- The four coding principles (think before coding / simplicity first / precise changes / goal-driven execution) are adapted from — and inspired by — the AI-coding guidelines shared by Andrej Karpathy.
