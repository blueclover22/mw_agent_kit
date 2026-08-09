---
name: dev-resume
description: Use on explicit user invocation when resuming or taking over work and the next concrete task itself is undecided. Not for an already-decided task (mak:dev-kickoff), a project with no documents yet (mak:reverse-engineering), or document-to-document consistency auditing (mak:doc-audit).
---

# mak:dev-resume — Work Re-Entry Point

Derives, from what project documents already show, (a) how far work has progressed, (b) problems in that state, (c) one concrete next step — each backed by evidence. Owns the **inbound** side of session handoff: finding out what to do, not doing it.

<HARD-GATE>
Diagnose, report, and route only.

Allowed: Read / Grep / Glob, read-only git commands, reproducing only the verification commands the documents actually claim (§Procedure step 3).
Forbidden: creating/modifying/deleting any file, any code change. Found defects go on the next-step candidate list — never fixed here.
</HARD-GATE>

## When to Use

Resuming in-progress work, or picking up a handed-off session, when the next concrete task itself is undecided.

Route elsewhere:

| Situation | Go to |
| :--- | :--- |
| No project documents at all | `mak:reverse-engineering` |
| Document drift dominates over "what's next" | `mak:doc-audit` |
| The roadmap/phase structure itself is stale | `mak:roadmap-planning` |
| The task is already decided | `mak:dev-kickoff` |

## Scope Rule

Fixed entry points only — inherits `mak:doc-audit` §Scope Rule; never a full codebase scan.

Entry points: roadmap SSOT status, design-doc `Status` values, recent commits, uncommitted changes — plus the paths/symbols those documents cite.

## Procedure

1. **Confirm current position** — read the entry points above
2. **Collect entry points** — trace cited paths/symbols per §Scope Rule
3. **Verify claims** — reproduce only commands that verify a claim the documents actually make (stated test counts, "clean" lint/build, etc.); read only cited code. No claim → no command
4. **Report diagnosis** — see §Report
5. **Present next steps** — 2–3 candidates, ask the user to choose. If a document already designates a next item, it must be one of the candidates

## Report

Reuse `mak:review-report` grades — 🔴 Critical / 🟡 Warning / 🟢 Pass / 📝 Note — no new grades. Every finding pairs a document's claim with the observed fact. Distinguish "no issue found" from "could not verify".

| Grade | Item | Location | Evidence (claim vs. observed) |
| :--- | :--- | :--- | :--- |

## Core Principles

- **Never fix** — defects become next-step candidates, not edits
- **No unsupported findings** — every finding cites its evidence
- **Candidates are always plural** — never present a single forced next step
- **Respect existing designations** — a next item the documents already name is never displaced by newly found issues; present it alongside them
