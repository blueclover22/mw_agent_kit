---
name: brainstorming
description: Use when requirements are vague or multiple approaches are possible — diverge and explore ideas before narrowing candidates, ahead of concrete design. If the direction is already decided, use mak:dev-kickoff instead.
---

# Idea Divergence — Expanding the Possibility Space

This skill is responsible for **divergence (expand) plus light ranking** — pouring out candidates, then a quick evaluation and top-pick recommendation to close out the divergence stage. Detailed requirements convergence and design-doc writing belong to the follow-up skills (`mak:dev-kickoff`, `mak:design-doc-template`).

Write all user-facing output in the user's conversation language (or the project's documented language policy).

<HARD-GATE>
Do not implement, write design documents, or create/modify files of any kind.

Read-only investigation (Read, Grep, Glob, git log, etc.) is allowed and encouraged for context gathering. Prohibited writes: creating, modifying, or deleting code or document files.
</HARD-GATE>

## When to Use

Enter this skill when one or more of the following applies:

- Requirements are vague or ambiguously phrased
- Multiple approaches are possible and the user is unsure which is right
- Requests like "how should we do this", "I need ideas", "let's discuss direction"

Conversely, skip this skill and go straight to `mak:dev-kickoff` when:

- Requirements are concrete and the goal is clear
- The technical approach is already largely decided

### Route to a different skill when

- Direction is set and only detailed requirements need narrowing → `mak:dev-kickoff`
- Establishing/updating the project-wide **phase structure** or mid/long-term roadmap → `mak:roadmap-planning`
- Writing a **design doc** for a specific feature/module to spec → `mak:design-doc-template`

## Procedure

Perform in order:

1. **Clarify the problem/goal** — limit to 1–2 questions to grasp the core. Do not dig into detailed requirements (that is `mak:dev-kickoff` territory).
2. **Multi-perspective exploration** — derive ideas from technical / user / operations / cost / time perspectives.
3. **Diverge** — list **at least 5** ideas. Pour them out first without censoring or self-review. Include at least one simplest-possible alternative among the candidates.
4. **Quick evaluation** — summarize each idea's appeal, feasibility, simplicity, and risk in one line.
5. **Simpler-alternative check** — before narrowing to top candidates, ask "is there an even simpler way?" If the user's initial idea seems excessive, push back explicitly.
6. **Recommend top 2–3** — present with reasons.
7. **Handoff guidance** — once the user picks a direction, guide: "To proceed in this direction, move to the `mak:dev-kickoff` skill for requirements convergence and design entry."

## Core Principles

- **Separate ideation from judgement** — do not evaluate quality while listing ideas
- **Go for quantity** — fill 5+ first, then cut
- **Welcome wild ideas** — record them even if they look infeasible
- **No detailed design or implementation specifics** — defer to `mak:dev-kickoff`
- **Check project convention docs first** — read `CLAUDE.md`, `README.md`, etc. for context

## Output Format

Present divergence results to the user in this shape (render headings in the user's language):

```markdown
## Divergence Results

### Ideas by Perspective

- [Technical] ...
- [User] ...
- [Operations] ...
- [Cost] ...
- [Time] ...

### Evaluation Summary

| Idea | Appeal     | Feasibility | Simplicity | Risk       |
| :--- | :--------- | :---------- | :--------- | :--------- |
| ...  | high/mid/low | high/mid/low | high/mid/low | high/mid/low |

### Recommendations

1. ... — reason: ...
2. ... — reason: ...
```
