---
type: Domain
related_to:
  - "../03.conventions.md"
  - "../04.framework.md"
  - "../05.layers.md"
---

# `<domain>` Domain

> Template: copy this file to `domains/<name>.md` (kebab-case, e.g. `payments.md`, `hw-interface.md`). Replace `<domain>` with the actual domain name, register the file in [`../00.INDEX.md`](../00.INDEX.md) §Domains, and delete this notice. This file stays in `domains/` as the copy source. Permanent guide.

Records the facts of the project feature domain `<domain>` — a vertical slice that cuts across layers. Per-layer conventions follow [`../05.layers.md`](../05.layers.md); this file holds only what is specific to the domain.

---

## 1. Domain Overview
_(TODO)_ Responsibility scope and boundaries, key terms (term names in [`../03.conventions.md`](../03.conventions.md) §2 Domain Terms).

## 2. Core Entities / Models
_(TODO)_ Key entities/types and their code locations.

## 3. State Machines / Flows
_(TODO)_ State transitions and key flows. End-to-end call chains that pass through this domain are traced in `../processes/<name>.md` — link them here, do not repeat them.

## 4. External Integrations / Contracts
_(TODO)_ External systems and the contracts this domain owns (contract list in [`../04.framework.md`](../04.framework.md) §5 Contract Catalog).

## 5. Conventions / Policies
_(TODO)_ Domain-specific rules (security, validation, exceptions, etc.).
