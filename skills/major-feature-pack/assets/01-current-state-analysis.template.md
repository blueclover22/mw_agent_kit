# 01. Current State Analysis

This document captures, at the code level, the state of the current {{project name}} before the origin {{domain}} is applied,
and makes the gaps against the **origin baseline** explicit.

---

## 1. Current flow summary

```text
{{current code flow diagram or directory structure}}
```

{{1–3 paragraphs of core diagnosis of current behavior. State whether it is absent, a placeholder stub, or a partial implementation.}}

---

## 2. Gaps vs. origin / external spec baseline (snapshot)

> In a new-adoption scenario where the current code is absent, fill this section as "unimplemented areas" (origin behavior → behavior this design will create).

| Area                  | Origin baseline                            | Current code                               | Gap                                               |
| :-------------------- | :----------------------------------------- | :----------------------------------------- | :------------------------------------------------ |
| {{area 1}}            | {{origin behavior / spec}}                 | {{current behavior / absent}}              | ❌ / ⚠ / ✓ — {{one-line reason}}                  |
| {{area 2}}            | ...                                        | ...                                        | ...                                               |
| {{area N}}            | ...                                        | ...                                        | ...                                               |

> ❌ = gap exists (must be resolved), ⚠ = intentional deviation, ✓ = aligned

---

## 3. Per-component details

### 3.1 {{component name}}

[{{current code path}}]({{current code path}})

```{{language}}
{{current code excerpt — key 5–30 lines}}
```

**Observations / issues**

- {{issue 1}}
- {{issue 2}}

### 3.2 {{component name}}

(repeat as needed — typically 4–8 components)

---

## 4. Consolidated identified problems

| #   | Problem                                                    | Impact                                            | Follow-up |
| :-- | :--------------------------------------------------------- | :------------------------------------------------ | :-------- |
| P1  | {{one-line problem}}                                        | {{one-line impact}}                               | §{{N}}    |
| P2  | {{one-line problem}}                                        | {{one-line impact}}                               | §{{N}}    |
| ... | ...                                                         | ...                                               | ...       |

---

## 5. Mapping to origin Known Issues

> Write this section only if the origin defines IS-N items. Omit for external standard specs, etc.

| origin IS-N                                | Handling in this design                                                      |
| :----------------------------------------- | :-------------------------------------------------------------------------- |
| IS-1 — {{original item, one line}}         | {{handling in this design — which § covers it}}                              |
| IS-N — {{original item, one line}}         | {{handling in this design}}                                                  |

---

## 6. Entry conditions for this pack (prerequisite work)

This pack may only be entered after all of the following are complete.

| Preceding pack / Phase          | Item this pack depends on                                                      |
| :------------------------------ | :---------------------------------------------------------------------------- |
| `{{preceding pack or Phase 1}}` | {{one-line dependency}}                                                        |
| `{{preceding pack or Phase 2}}` | {{one-line dependency}}                                                        |

{{If there is no prerequisite work, state "This pack can be entered standalone — no external prerequisite dependencies."}}
