---
type: DomainGuide
related_to:
  - "../01.Glossary.md"
  - "../05.framework-api.md"
  - "../06.frontend-guide.md"
  - "../07.backend-guide.md"
  - "../12.process-guide.md"
---

# `<domain>` Guide

> Template: copy this file to `domains/<domain>-guide.md` (e.g. `payments-guide.md`, `hw-interface-guide.md`). Replace `<domain>` with the actual domain name and delete this notice. Register it in the index at [`../08.domains.md`](../08.domains.md) §1. Permanent guide.

Defines the conventions of the project feature domain `<domain>`. As a vertical slice that cuts across layers, the UI follows [`../06.frontend-guide.md`](../06.frontend-guide.md) and the core follows [`../07.backend-guide.md`](../07.backend-guide.md) conventions.

---

## 1. Domain Overview
_(TODO)_ Responsibility scope and boundaries, key terms (term definitions in [`../01.Glossary.md`](../01.Glossary.md)).

## 2. Core Entities / Models
_(TODO)_ Key entities/types and their code locations.

## 3. State Machines / Flows
_(TODO)_ State transitions and key flows. Call chain tracing in [`../12.process-guide.md`](../12.process-guide.md).

## 4. External Integrations / Contracts
_(TODO)_ External systems and contracts (contract list in [`../05.framework-api.md`](../05.framework-api.md)).

## 5. Conventions / Policies
_(TODO)_ Domain-specific rules (security, validation, exceptions, etc.).
