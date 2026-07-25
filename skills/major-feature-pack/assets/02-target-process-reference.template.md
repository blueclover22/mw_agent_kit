# 02. Target Process (origin reference)

This document summarizes, in one place and from a design perspective, the **origin {{domain}} process**
that this {{project name}} project must follow. The primary sources are:

- `{{primary source — spec document / existing code / external SDK docs, etc.}}` (in full)
- {{secondary sources — additional documents / code / specs}}

This document specifies **what to carry over as-is and what to substitute for the target environment**
when porting to {{current project environment — e.g. TypeScript + React, Java + Spring Boot, Rust + Tauri, etc.}}.

---

## 1. {{Key components / domain classification}}

| Code / identifier | origin name | Mapping in this design            | In scope     |
| :------------ | :---------- | :-------------------------------- | :----------- |
| `{{code}}`    | {{name}}    | `{{this design's enum / type / module}}` | ✓ / ❌  |
| ...           | ...         | ...                               | ...          |

> For out-of-scope items, state a one-line reason.

---

## 2. {{Key specifications}}

Written differently per domain. Examples:

- Communication protocol: message fields / headers / response codes
- State machine: state codes / transition table
- API spec: endpoints / methods / schemas
- Data model: tables / columns / constraints

### 2.1 {{Spec 1 — matrix}}

| Item      | Value / format / meaning      | Handling in this design                     |
| :-------- | :---------------------------- | :------------------------------------------ |
| {{field}} | {{origin value}}              | {{mapping in this design}}                  |
| ...       | ...                           | ...                                         |

### 2.2 {{Spec 2}}

(as many as needed)

---

## 3. {{Key flows / sequences}}

### 3.1 {{Flow name 1}}

```text
{{origin sequence diagram — text or mermaid}}
```

### 3.2 {{Flow name 2}}

(as many as needed)

---

## 4. {{Current-environment equivalents / substitutions}}

| origin step / component                  | Equivalent in this design                             |
| :--------------------------------------- | :---------------------------------------------------- |
| {{origin component 1}}                   | {{mapping in this design — which module / trait / API}} |
| {{origin component 2}}                   | {{mapping in this design}}                            |

---

## 5. {{Known Issues / known defects — porting avoidance}}

> Write this section only if the origin defines IS-N. Omit for standard specs / external SDK docs.

| Defect / recommendation                  | Handling in this design                                                      |
| :--------------------------------------- | :--------------------------------------------------------------------------- |
| IS-N — {{original item, one line}}       | {{this design — naturally avoided / corrected / not adopted}}                |

---

## 6. Intentional deviations of this design from origin

> Aligned with the table of the same name in 00-index.md. Both documents hold the same table.

| Area                | origin                          | This design                                      | Reason                                        |
| :------------------ | :------------------------------ | :----------------------------------------------- | :-------------------------------------------- |
| {{area name}}       | {{origin behavior}}             | {{this design's behavior}}                       | {{one-line reason for deviation}}             |

---

## 7. Origin behaviors this design must be aware of

Implicit origin behaviors that this design carries over as-is but must make explicit in code / policy.

| origin behavior                          | Meaning in this design                                                    |
| :--------------------------------------- | :------------------------------------------------------------------------ |
| {{origin's implicit rule 1}}             | {{this design — how it will be made explicit / enforced}}                  |
| {{origin's implicit rule 2}}             | {{handling in this design}}                                                |
