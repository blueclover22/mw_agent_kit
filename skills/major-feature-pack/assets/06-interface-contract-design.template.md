# 06. Interface Contract Design (system boundary contract)

This document defines the **interface contract** that the §05 module design exchanges with the outside
(frontend / other services / external systems / caller libraries). Choose the form that fits the project
environment (Tauri IPC / HTTP API / gRPC / FFI / module exports, etc.) and document it in a consistent format.

---

## 0. Scenario mapping

How the items defined in this document map per project environment:

| Scenario                        | Form of "command"                       | Form of "event"               | Type definition location    |
| :------------------------------ | :-------------------------------------- | :---------------------------- | :-------------------------- |
| Tauri desktop                   | Tauri IPC command (`invoke`)            | `emit` / `Channel<T>`         | Rust struct + TS type       |
| Client-server (HTTP/REST)       | REST endpoint                           | SSE / WebSocket               | OpenAPI / JSON Schema       |
| Client-server (gRPC)            | RPC method                              | server stream                 | `.proto` definitions        |
| Native mobile                   | Platform interface (Swift / Kotlin)     | Notification / Combine flow   | Per-language types (Swift / Kotlin)|
| Library / FFI                   | Public function signatures              | callback                      | Headers / module exports    |
| Single process (no separation)  | Module exports                          | Observer / event emitter      | Per-language types          |

> **This project's scenario**: {{choose — one or more rows from the table above}}
> **Response wrapper / error model**: {{project alignment — e.g. `IpcResult<T>` / `ApiResponse<T>` / `Result<T, Error>` / OpenAPI `default` error schema, etc.}}

In the body below, "command" / "event" / "type" / "sequence" are interpreted in the corresponding form per the mapping above.

---

## 1. Command (or equivalent) list

| Command / method / endpoint     | Direction             | Response type             | Description                   | New/changed |
| :------------------------------ | :-------------------- | :------------------------ | :---------------------------- | :-------- |
| `{{name}}`                      | {{caller → callee}}   | `{{Type}}`                | {{one-line description}}       | New       |
| `{{name}}`                      | {{caller → callee}}   | `{{Type}}` + async push   | {{description — Channel / stream}} | New   |
| ...                             | ...                   | ...                       | ...                           | ...       |

---

## 2. Event / async push list

| Event / stream                    | Identifier / type                        | Direction   | payload                  | Emission timing            |
| :-------------------------------- | :--------------------------------------- | :---------- | :----------------------- | :------------------------- |
| `{{event_name}}`                  | `EVENT_{{NAME}}` / topic / etc.          | BE → FE     | `{{PayloadType}}`        | {{when it is emitted}}     |
| `{{stream_type}}`                 | `Channel<{{T}}>` / Server-Sent Event, etc. | BE → FE   | `{{ProgressEnum}}`        | {{per-step progress push}} |
| ...                               | ...                                      | ...         | ...                      | ...                        |

---

## 3. Type definitions

### 3.1 `{{TypeName}}` ({{source definition — Rust / Java / TS / .proto / OpenAPI, etc.}})

```{{language}}
{{type definition}}
```

### 3.2 `{{TypeName}}` ({{counterpart side — TypeScript / Java / Swift / Kotlin / etc.}})

```{{language}}
{{counterpart definition}}
```

> Core principle: **sensitive fields / raw responses from external systems** are never exposed to the outside (callers / frontend) (aligned with {{related D items}}).

### 3.3 Response wrapper / common error model — no change

This project's default wrapper ({{`IpcResult<T>` / `ApiResponse<T>` / `Result<T, Error>`, etc.}}) keeps the existing convention as-is.

---

## 4. Command specifications

### 4.1 `{{name}}`

**Input** `{{schema}}`

**Response** `{{ResponseType}}`

**Processing** (server-side, §05 §{{N}}):

1. {{step 1}}
2. {{step 2}}
3. ...

**Error codes**:

- `{{ERROR_CODE}}` (retryable=true/false) — {{when it occurs + user message}}

**Caller-side usage**:

```{{language}}
{{call example code — invokeTauri / fetch / gRPC client / FFI call, etc.}}
```

### 4.2 `{{name}}`

(repeat — typically 3–8 commands)

---

## 5. Event specifications

### 5.1 `{{event_name}}`

**Emission timing**:

- {{trigger condition}}

**payload** `{{PayloadType}}`

**Receiver-side handling**:

```{{language}}
{{listen / subscribe / handler example}}
```

---

## 6. Error code table

| Code                                | retryable  | Origin location           | User message (example)                                                 |
| :---------------------------------- | :--------- | :------------------------ | :--------------------------------------------------------------------- |
| `{{ERROR_CODE}}`                    | true/false | `{{command / function}}`  | {{message shown to the user}}                                           |
| ...                                 | ...        | ...                       | ...                                                                    |

`AppError.kind` or equivalent classification — all aligned to caller-side classification with `kind: "{{domain}}"`.

---

## 7. Sequences (summary)

### 7.1 Happy path

```text
Caller                        Callee ({{name}})             {{external system}}
│ {{call}}
├──────────────────────────►│
│                           │ {{step 1}}
│                           │ {{step 2}} ──────────────────►│
│                           │ ◄──── {{response}}
│ ◄── {{response}}
```

### 7.2 Partial failure / user cancellation / external system rejection

(as many as needed — typically 3–5 sequences: happy path / partial failure / user cancellation / external rejection, etc.)

---

## 8. Caller-side wrapper change summary

`{{caller-side code path}}`:

```{{language}}
{{wrapper / api client code}}
```

---

## 9. Compatibility / regression checklist

- [ ] {{sensitive-field absence verification — static grep confirms absence of raw card data / tokens / passwords, etc.}}
- [ ] {{serialization format alignment — verification matching the scenario: Tauri Channel `tag="event"` / OpenAPI schema / .proto, etc.}}
- [ ] {{idempotency / guards / permission verification}}
- [ ] {{compatibility with existing contract — state version / breaking change / backwards-compat}}
- [ ] {{error code classification aligned with caller-side automatic handling (auto toast / retry / routing, etc.)}}
