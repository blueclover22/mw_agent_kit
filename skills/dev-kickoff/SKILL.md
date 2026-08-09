---
name: dev-kickoff
description: Use to kick off Non-trivial / Risky work, or when task sizing is unclear. Skip for obviously Trivial / Small work (typos, formatting, one-line or single-file fixes); if judged Trivial / Small after entering, exit to the lightweight flow. If direction itself is vague, run mak:brainstorming first. Sizing criteria and the approval gates are in the skill body.
---

# Development Kickoff — Turning Requirements into an Approvable Design

This skill owns conversational orchestration. Before implementation starts, the main thread narrows requirements, requests non-interactive architecture consultation from `mak:planner` when needed, and converges user decisions into an approved design. It is not the repeated author of the final design doc.

Conduct the conversation and all user-facing output in the user's language (or the project's documented language policy).

## Sizing criteria (entry judgement)

Enter for behavior changes spanning multiple files/modules, new features/components, architecture decisions, or suspected impact on data models, dependencies, security, or migration. When the boundary is unclear, judge by impact: roughly single-file/few-lines with no change to public interfaces, data shapes, or dependencies → Trivial / Small (do not enter); spanning 2+ files/modules or changing interfaces, data models, dependencies, or security → Non-trivial or above (enter).

### Route to a different skill when

- Direction itself is vague and idea divergence is needed first → `mak:brainstorming`
- Establishing/updating the project-wide **phase structure** or mid/long-term roadmap → `mak:roadmap-planning`
- Writing a feature/module **design doc** to spec → `mak:design-doc-template`
- The task itself is undecided and must be derived from the documents → `mak:dev-resume`

<HARD-GATE>
Two approvals gate two different actions — do not conflate them:

1. **Design-content approval (§6)** — until the user approves the presented design content, no writes of any kind (file creation, modification, deletion).
2. **Implementation-start approval (§9–§10)** — until the user approves against the saved document, no implementation writes.

The ONLY writes permitted between the two gates are: saving the design doc itself (§7, requires §6 approval first) and subsequent edits to that same document (§8 self-review fixes, §9 user change requests). Nothing else is written until §10.

Reading files, read-only commands (git log, ls, grep, etc.), and search tools are allowed and encouraged throughout. Exception: if sizing clearly comes out Trivial / Small, stop this skill and switch to the general lightweight flow.
</HARD-GATE>

## Checklist

Complete in order:

1. **Explore project context** — README, CLAUDE.md, docs/, recent commits, related source files
2. **Clarifying questions** — one at a time until purpose, constraints, and success criteria are clear
3. **Decide on planner consultation** — Non-trivial: as needed; Risky / multi-module / migration: request a `mak:planner` Architecture Brief as a rule
4. **Propose 2–3 approaches** — with trade-offs and a recommendation, based on the planner report or main-thread investigation (include at least one simpler alternative)
5. **Convert to verifiable goals** — turn the task into measurable success criteria and a `Step → verify: check` plan
6. **Present the design** — present section by section, proceeding after each section's approval
7. **Documentation handoff** — pass the confirmed design inputs to `mak:planner`, or only if planner is unavailable, the main thread saves it per the `mak:design-doc-template` spec
8. **Self-review** — unconfirmed decisions, contradictions, scope problems + simplicity / precise-changes self-check
9. **User review gate** — wait for user confirmation
10. **Handoff to next stage** — see the Handoff section below

## Procedure

### 1. Explore project context

Before asking questions:

- `README.md` for project overview, setup, purpose
- `CLAUDE.md` (or `AGENTS.md`, `GEMINI.md`) for project rules and agent definitions
- `docs/` and the project's design-doc path for existing architecture decisions
- Recent git commits for current direction
- Existing patterns related to the request

### 2. Clarifying questions

- One question per message — do not stack multiple questions
- Offer multiple-choice options when enumerable
- Focus on: purpose, constraints, success criteria, known non-goals
- If the request spans independent subsystems, confirm decomposition before detailed discussion
- If the user explicitly asks for "all questions at once", number them in a single message

### 3. Decide on planner consultation

Decide by task grade whether to call `mak:planner`.

- **Trivial / Small**: stop this skill and switch to the lightweight flow (direct or `mak:coder`). Do not call planner.
- **Non-trivial**: request a planner Architecture Brief when the existing structure is complex or options genuinely diverge.
- **Risky / multi-module / migration**: request a planner Architecture Brief as a rule.

When calling planner, pass along the requirements confirmed so far, constraints, relevant doc/code paths, and candidate user questions. Planner cannot talk to the user, so the main thread discusses the "decisions needed" items from planner's report with the user and confirms them.

### 4. Propose approaches

- Always present 2–3 options. Never just one
- Include at least one simpler alternative. If the user's initial idea seems excessive, push back explicitly and recommend the simpler option
- Lead with the recommendation and explain why
- Include concrete trade-offs (complexity, simplicity, performance, maintainability, reversibility)
- If hard constraints leave only one real option, state the constraint and proceed with a single option. Do not fabricate alternatives

### 5. Convert to verifiable goals

Before moving to design, convert the request into measurable success criteria.

**Conversion examples**:

| Vague request | Verifiable goal |
| :--- | :--- |
| "Add validation" | Write and pass tests for invalid inputs |
| "Fix the bug" | Write a test reproducing the bug and make it pass |
| "Refactor X" | Identical tests pass before and after |
| "Make the slow screen fast" | Specify measurement point, method, and target (e.g. initial render < 200ms) |

**Multi-step plan**: if the work has 2+ steps, produce:

```
1. <Step>  → verify: <check>
2. <Step>  → verify: <check>
3. <Step>  → verify: <check>
```

This table goes into the design doc as §5.0, inside its §5 verification plan (see `mak:design-doc-template`).

Clear success criteria enable independent iteration. Narrow vague criteria like "just make it work" before proceeding.

### 6. Present the design

- Write each section at a length matching its complexity (a few sentences for simple content, up to ~300 words for complex content)
- Cover: architecture, component boundaries, data flow, error handling, test strategy
- Request approval after each section. Revise on feedback, then proceed

### 7. Documentation handoff

Runs only after §6 design-content approval — this is the first write in the flow, and all writes before §10 are limited to this design doc (see HARD-GATE). The approved design is documented **once**, per the `mak:design-doc-template` spec (sections, save location, file naming). This step's core responsibility is producing the confirmed inputs to hand to `mak:planner`.

- If the `mak:planner` agent is available: **delegate the writing by passing the confirmed design inputs** — purpose/non-goals, chosen option, scope of changes, verification plan, confirmed decisions, remaining uncertainties. Planner is non-interactive, so leave no items that require asking the user. Once delegated, do not rewrite the same document in later steps (§10).
- If planner is unavailable: the main thread writes it directly.
- `mak:dev-kickoff` itself never loops draft-then-planner-rewrite on the same document.

**No git commits** — version control is done by the user, except on explicit request or when project rules say otherwise.

### 8. Self-review

Before the documentation handoff (or after writing directly), check:

- **Incomplete items** — any "TBD", "TODO", unclear requirements? Items needing user decisions get confirmed in the main thread; only genuinely technical uncertainty goes to §Assumptions/Unreviewed.
- **Consistency** — do sections contradict each other?
- **Scope** — focused on a single implementation cycle?
- **Ambiguity** — any requirement readable two ways? Pick one and make it explicit.
- **Simplicity** — unrequested features / speculative flexibility / impossible-scenario error handling / excessive abstraction? Remove them.
- **Precise changes** — does every §4 scope item connect directly to the user's request? Split out anything that doesn't.
- **Verifiability** — does §5.0 contain measurable success criteria or a `Step → verify` table?

Fix immediately. No re-review needed.

If self-review produced substantive changes beyond typos, mention them briefly when handing the document to the user.

### 9. User review gate (implementation-start approval)

> "The design doc is saved at `<path>`. Please review and tell me anything that needs changing. If it looks good, reply 'proceed' or 'approve'. I'll continue to the next stage after explicit confirmation."

Wait for confirmation. On change requests, apply them to the design doc and re-run the self-review; if a change alters an already-approved design decision (not just wording), re-present that section per §6 before proceeding.

### 10. Handoff to next stage

Once the design is approved:

```
1. Confirm design approval
   - The user explicitly confirmed ("approve", "proceed", "OK", etc.)
   - Never move on without approval
   - The design doc was already written once in §7 — do not rewrite it here

2. Delegate implementation to coder after approval
   - If the mak:coder agent is available:
       → delegate to mak:coder (pass the approved design doc path)
   - Otherwise:
       → implement directly (the design doc is the SSOT for scope)

3. Delegate review on major-stage completion
   - If the mak:reviewer agent is available:
       → delegate to mak:reviewer (pass review scope and design doc path)
   - Otherwise:
       → self-review by applying the mak:review-report checklist directly

4. Delegate doc sync when needed
   - If the mak:doc-editor agent is available:
       → delegate to mak:doc-editor (pass the list of documents to sync)
   - Otherwise:
       → update documents directly
```

The design doc is the source of truth. All subsequent agents (or direct work) operate against it.

## Core Principles

- **One question at a time** — never stack questions
- **YAGNI** — cut anything not needed for the stated goal
- **Explore first** — always check existing patterns before proposing
- **Incremental approval** — present, collect feedback, revise; never batch it all
- **Explicit trade-offs** — every option must include concrete downsides
