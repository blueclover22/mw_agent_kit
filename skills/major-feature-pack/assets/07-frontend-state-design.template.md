# 07. Frontend State Design

This document defines the types / screens / state / routing of the frontend `{{feature}}` to match the §06 interface contract changes.

> This template is framework-agnostic. Write it for the project's frontend stack:
> React + TanStack Query / Vue + Pinia / Svelte + stores / Angular + RxJS / SwiftUI + Combine / Jetpack Compose + Flow / etc.
> Terms like "mutation" / "query" follow the TanStack Query convention — for other stacks, substitute their equivalents (action / effect / async observer, etc.).

Core principles:

1. {{core principle 1 — e.g. sensitive data never reaches the frontend}}
2. {{core principle 2 — e.g. single mutation + Channel subscription / single action + observer}}
3. {{core principle 3 — e.g. memory only / no exposure to client storage}}

---

## 1. Files to change

| File                                                              | Change                                                        |
| :---------------------------------------------------------------- | :------------------------------------------------------------ |
| `{{type definition path}}`                                         | {{add type definitions}}                                        |
| `{{api call wrapper path}}`                                       | {{interface call wrapper — invokeTauri / fetch / gRPC client / etc.}} |
| `{{query / store path}}`                                           | {{query / mutation / store / observer hooks}}                   |
| `{{component path}}`                                               | {{screen components — JSX / template / SwiftUI View / Composable}}  |
| `{{entry point}}`                                                  | export / router registration                                   |

---

## 2. types definitions

`{{type definition path}}`:

```{{language}}
{{type definitions — literal unions like DeviceKind / PaymentMethod, label maps, response types, type guards}}
```

> **Sensitive fields are absent at the type level** — the compiler blocks accidental use.

---

## 3. API wrapper

```{{language}}
{{api wrapper — invokeTauri / fetch / axios / gRPC client / URLSession / Retrofit, etc.}}
```

---

## 4. mutation / query / state management

> Usage patterns follow the project stack. Below is a React + TanStack Query example — substitute equivalents for other stacks.

### 4.1 `{{mutation name}}`

```{{language}}
{{mutation / action / async function definition — call + onSuccess + onError pattern}}
```

### 4.2 `{{query name}}`

(as many as needed)

---

## 5. Screens / components

### 5.1 `{{ComponentName}}`

```{{language}}
{{key component skeleton — per-framework form}}
```

### 5.2 `{{ComponentName}}`

(as many as needed)

---

## 6. Routing / guards

{{Routing changes / guard additions / entry conditions. State explicitly if there are no changes.}}

---

## 7. UI / UX notes

- {{design decisions — labels / icons / progress indication / error tone / accessibility}}
- {{future change guidance — one-line guiding memo}}

---

## 8. Security / verification checklist

- [ ] `{{sensitive field}}` is absent anywhere in frontend code / types / components (static grep)
- [ ] {{sensitive data}} is never stored in any client storage (`localStorage` / `IndexedDB` / `SharedPreferences` / `UserDefaults` / etc.)
- [ ] {{type exhaustiveness — missing switch / match arms caught at compile time}}
- [ ] {{single subscription to events / streams — prevent races / duplicate handling}}
- [ ] {{permissions / guards — entry only after admin / authentication checks, etc.}}
