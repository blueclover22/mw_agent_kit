# mak — MW Agent Kit

> A development-process plugin for Claude Code — provides the diverge → kickoff → design → implement → verify → review flow as skills and agents.
>
> 한국어 버전: [README.md](README.md)

`mak` is a Claude Code plugin for reproducing the same development process in any language/stack. It ships 10 skills and 5 agents, with no dependency on a specific framework or build tool.

---

## 1. Install

```bash
# 1. Register the marketplace (once)
claude plugin marketplace add blueclover222/mw_agent_kit
#    (from a local checkout: claude plugin marketplace add /path/to/mw_agent_kit)

# 2. Install the plugin
claude plugin install mak@mw-agent-kit
```

Then, in a Claude Code session, **install the common rules once**:

```
/mak:setup
```

This adds the Workflow task grades, the coding-principle mapping, and the mak delegation summary to `~/.claude/CLAUDE.md` as a marker block (`<!-- mak:begin -->` … `<!-- mak:end -->`). The rules are installed **in your conversation language** (Korean/English, auto-detected; override with `/mak:setup ko` or `/mak:setup en`). Re-running updates only the block; content outside the markers (your personal rules) is never touched.

## 2. Update

```bash
claude plugin update mak@mw-agent-kit
```

If the update changed the rules (snippet), re-run `/mak:setup` to refresh the block.

> A local-path marketplace does not refresh the cache when the version number is unchanged — during development, reinstall (uninstall → install) instead.

## 3. Uninstall

Before uninstalling, **remove the rules block first** (plugins have no uninstall hook):

```
/mak:teardown
```

```bash
claude plugin uninstall mak@mw-agent-kit
```

## 4. What's Included

### Skills (10)

| Skill | Role |
| :--- | :--- |
| `/mak:brainstorming` | Idea divergence when requirements are vague (no-implementation gate) |
| `/mak:dev-kickoff` | Kickoff for non-trivial work — requirements convergence, options, approval gate |
| `/mak:design-doc-template` | Design-doc format, save-location rule (SSOT), skeleton |
| `/mak:major-feature-pack` | Structured 9-doc design for broad-analysis features/ports |
| `/mak:roadmap-planning` | Project-wide phase structure and status tracking (top-level axis) |
| `/mak:verify-checklist` | Post-implementation order: build → lint → tests → format → manual |
| `/mak:review-report` | Review procedure and report format (Critical/Warning/Pass/Note) |
| `/mak:setup` | Install the common rules (workflow grades, principle mapping, delegation summary) into `~/.claude/CLAUDE.md` as a marker block |
| `/mak:teardown` | Remove the installed marker block (run before uninstalling) |
| `/mak:reverse-engineering` | Copy the standard 14-doc set and reverse-engineer the project |

### Agents (5)

| Agent | Model | Role |
| :--- | :--- | :--- |
| `mak:planner` | opus | Non-interactive architecture consultation (Architecture Brief), design-doc writing |
| `mak:coder` | sonnet | Implementation against an approved design |
| `mak:reviewer` | opus | Review and report only (never modifies code) |
| `mak:doc-editor` | haiku | Editing/syncing existing Markdown documents |
| `mak:analyzer` | opus | Code analysis / doc filling for reverse-engineering (never modifies code) |

## 5. Usage & Documentation

The basic development flow:

```
(if vague) /mak:brainstorming → /mak:dev-kickoff → [mak:planner brief if needed]
   → design doc (mak:design-doc-template / mak:major-feature-pack for large features)
   → user approval → implement (mak:coder) → /mak:verify-checklist → mak:reviewer review
```

- Obvious Trivial / Small work (typos, one-liners) skips the process entirely.
- Design docs are saved under the project's `.claude/mak/plan/` by default.
- To analyze and document an existing project, use `/mak:reverse-engineering`.

For the full process, task grades, decision criteria, and agent delegation principles, the **usage guide** is the single entry point:

| Document | Location |
| :--- | :--- |
| **Usage guide** (process detail) | [docs/guide.en.md](docs/guide.en.md) · [docs/guide.md](docs/guide.md) |
| Plugin development rules (for contributors) | [CLAUDE.md](CLAUDE.md) · [AGENTS.md](AGENTS.md) |

## 6. Customizing

Installed plugin files can't be edited in place. To adapt the kit, fork the repository, edit the skill `assets/` templates (design doc, review report, roadmap, 9-doc, doc set) and `skills/setup/assets/claude-md-snippet.ko.md` / `.en.md` (injected rules, ko/en mirrors), and distribute via your own marketplace.
