# 04. Data Model Design

This document fixes the §02 origin spec and the §03 policies ({{related D items}}) into code models.
The core models are the following {{N}}:

1. `{{model 1}}` — {{one-line description}}
2. `{{model 2}}` — {{one-line description}}
3. ...

> Write model definitions in the project's tech stack: Rust struct / Java class / TypeScript interface / Go struct / Python dataclass / proto message / JSON Schema, etc.

---

## 1. Classification criteria

| Classification    | Definition                                                 | Examples                                                          |
| :---------------- | :--------------------------------------------------------- | :---------------------------------------------------------------- |
| {{class 1}}       | {{definition}}                                             | {{example fields}}                                                |
| {{class 2}}       | {{definition}}                                             | {{example fields}}                                                |
| ...               | ...                                                        | ...                                                               |

---

## 2. Model composition

### 2.1 `{{model name 1}}`

[{{related code path}}]({{related code path}}) (new / modified)

```{{language}}
{{model definition — matching the project stack}}
```

> If multiple languages handle it simultaneously (e.g. both backend and frontend), write both definitions + state serialization alignment.

**Storage location**: {{in-memory / persistence location — database / file / local store / OS keychain, etc.}}

**Lifetime**: {{when it is created and when it is discarded}}

**Prohibited items** (code review checklist):

- {{prohibition 1 — e.g. storing plaintext passwords / card numbers / tokens}}
- {{prohibition 2}}

### 2.2 `{{model name 2}}`

(repeat — typically 4–8 models)

---

## 3. Storage-location matrix

> Specify, per data kind, where and in what form it is stored / serialized / discarded.

| Data                  | Location                              | Serialization | Lifetime                   | Notes                                                   |
| :-------------------- | :------------------------------------ | :------------ | :------------------------- | :------------------------------------------------------ |
| `{{data}}`            | {{memory / DB / file / OS store / etc.}} | JSON / proto / -| {{lifetime}}              | {{notes}}                                               |
| ...                   | ...                                   | ...           | ...                        | ...                                                     |

**Prohibition matrix**:

| Data                | Client storage     | Config file | Log file     | Memory (not cleaned up) |
| :------------------ | :----------------- | :-------- | :------------ | :------------------ |
| {{sensitive data 1}} | ❌                | ❌        | ❌            | ❌                  |
| {{sensitive data 2}} | ❌                | ❌        | △ masked      | ⚠ disposal enforced |
| {{non-sensitive data}} | ✓ as needed     | ✓         | ✓             | ✓                   |

> Interpret "client storage" per scenario — `localStorage` / `IndexedDB` / `SharedPreferences` / `UserDefaults` / `~/.config/<app>/`, etc.

---

## 4. Inter-model synchronization rules

```text
[{{event / flow start}}]
  {{method / function call}}
    ├─ {{model 1 change}}
    ├─ {{model 2 change}}
    └─ {{side effect}}

[{{another flow}}]
  ...
```

Ensure there is no path that can modify the models other than the N flows above ({{reduced visibility / explicit single entry point / restricted module exports, etc.}}).

---

## 5. Verification checklist

For this model to hold, all of the following must be true.

- [ ] {{model 1 serialization result verification — round-trip / expected field names / missing-field handling}}
- [ ] {{model 2 lifetime / disposal verification — Drop / dispose / explicit cleanup}}
- [ ] {{sensitive information masked in debug output / logs / serialization}}
- [ ] {{storage-location matrix — prohibited items yield 0 hits via static grep}}
- [ ] {{enum / sum type exhaustiveness — missing match / switch arms caught at compile time}}
- [ ] {{type compatibility — type alignment between backend and frontend / other services}}
