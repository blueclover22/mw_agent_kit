---
name: doc-audit
description: Use right after a slice/phase completes, at a phase transition, or before handing off an unfinished session — audits consistency across the project's own documents and the reality of code paths/symbols they cite. Not for comparing implementation against one design doc (mak:review-report), build/lint/test verification (mak:verify-checklist), or judging whether documented behavior matches the code (mak:analyzer).
---

# Document Audit Guide

Audits **document-to-document consistency** and the **reality of code paths/symbols the documents cite**. Other mak stages only diff code against one design doc — nothing checks whether the rest of the documents are still valid.

Report only, in the user's language — **never edit documents**. Fixes go through `mak:doc-editor` or the main thread.

---

## When to Use

- Right after a slice/phase completes
- At a phase transition
- Before handing off an unfinished session

**Do not run on every commit** — this targets accumulated drift across documents, not a single change.

Route elsewhere: implementation vs. one design doc → `mak:review-report`; build/lint/tests → `mak:verify-checklist`; whether documented *behavior* matches code → `mak:analyzer`.

## Audit Surface

Audit only what exists; silently skip what doesn't.

| Surface | Where |
| :--- | :--- |
| Design docs (master + sub-docs) | per the `mak:design-doc-template` save-path rule |
| 9-doc packs | `mig_*/`, `feat_*/` |
| Roadmap | per the `mak:roadmap-planning` save-path priority |
| Permanent doc set | `docs/` |

If `docs/00.INDEX.md` / `docs/CLAUDE.md` exist, they are the SSOT for that set's structure and per-topic ownership — audit against them. If absent, treat `docs/*.md` as plain documents and never invent structure.

## Scope Rule

Fixed entry points — never scan everything, unless the user explicitly requests a full scan.

1. Collect entry points — slice IDs / documents / source files or symbols changed or completed this cycle
2. Trace backward — grep each entry point across the audit surface
3. Audit only entry-point documents + grep hits — read nothing else

## Checklist

1. **Back-reference tracking** — grep changed slice IDs/symbols; do referencing documents match the post-change content?
2. **Dangling references** — references to nonexistent symbols, sections, documents, or code paths/identifiers
3. **Mismarked completion** — marked done while residual tasks remain
4. **Cross-document contradiction** — phase placement/status differs between documents
5. **SSOT inversion** — a derived document contradicts its SSOT (sub-doc vs. master, sub-doc vs. 9-doc pack, `docs/` per-topic SSOT)

### Handoff Check

Only at session handoff. Single question: can the next session identify one concrete task to start from the documents alone (yes/no + evidence)?

### Non-goals

Whether documented behavior/flow matches the code is out of scope — that needs code reading, not comparison (`mak:analyzer`'s job). If a drift signal appears (symbol exists but signature/arity differs from the doc, or cited code changed substantially after the doc's last update), do not judge it here — record it as a 📝 Note recommending `mak:analyzer` re-analysis.

## Report

Reuse `mak:review-report`'s grades: 🔴 Critical / 🟡 Warning / 🟢 Pass / 📝 Note — no new grades. Every finding needs evidence (a grep hit, or two contradicting locations). State the entry points used and the derived audit surface at the top. Distinguish "no issues found" from "could not verify".

| Grade | Item | Location | Evidence | Suggested fix |
| :--- | :--- | :--- | :--- | :--- |

If clean: `✅ No cross-document inconsistencies found`
