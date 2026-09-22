---
type: Process
related_to:
  - "../01.overview.md"
  - "../02.architecture.md"
  - "../04.framework.md"
  - "../05.layers.md"
---

# `<scenario>` Process

> Template: copy this file to `processes/<name>.md` (kebab-case, e.g. `checkout.md`, `app-startup.md`) — one representative user scenario per file. Replace `<scenario>` with the scenario name, register the file in [`../00.INDEX.md`](../00.INDEX.md) §Processes, and delete this notice. This file stays in `processes/` as the copy source. Permanent guide.

Traces the internal behavior of one scenario from "user action → resulting output" as a call chain. **During analysis these files are filled first** — the trace reveals the layers, module boundaries, and key files that the core documents then describe ([`../CLAUDE.md`](../CLAUDE.md) §2). Record what the code does, not what it should do.

---

## 1. Trigger and Result
_(TODO)_ What starts the scenario (user action / event / schedule), its entry point (path — listed in [`../01.overview.md`](../01.overview.md) §3), and the observable result.

## 2. Call Chain at a Glance
_(TODO)_
```
EntryPoint (path)
  └─► Layer A: symbol (path)
        └─► Layer B: symbol (path)
              └─► result
```

## 3. Step-by-Step Details
_(TODO)_ One row per hop — what it receives, what it decides, what it hands on.

| # | Layer | File : symbol | Responsibility in this scenario | Notes (branches · errors) |
| :-- | :--- | :--- | :--- | :--- |
| 1 | `<layer>` | `<path>:<symbol>` | ... | ... |

## 4. Sequence Diagram
_(TODO — optional. mermaid `sequenceDiagram`; mind dark-theme readability and `<generics>`/reserved words in participant aliases)_

## 5. Related Documents
_(TODO)_ Contracts crossed ([`../04.framework.md`](../04.framework.md) §5), layers touched ([`../05.layers.md`](../05.layers.md)), domains involved (`../domains/<name>.md`), architecture rules exercised ([`../02.architecture.md`](../02.architecture.md)).
