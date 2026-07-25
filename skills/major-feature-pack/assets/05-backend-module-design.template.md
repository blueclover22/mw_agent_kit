# 05. Backend Module Design

This document translates the §03 policies and §04 models into code structure.
The main new / changed modules are as follows.

```text
{{directory tree — mark new / modified. Match the project structure}}
{{root}}/
  {{existing module}}                          ← {{one-line change}}
  {{new feature / package}}/        (new)
    {{submodule 1}}                            ← {{role}}
    {{submodule 2}}                            ← {{role}}
    ...
  {{entry point / main / lib / etc.}}          ← {{one-line change}}
```

> Tree notation follows the project convention — Rust crate (`src-tauri/src/...`) / Java package (`src/main/java/...`) / TypeScript module (`src/...`) / Go package (`internal/...`) / Python package (`<pkg>/...`), etc.

---

## 1. Dependency additions

`{{dependency manifest — Cargo.toml / package.json / pom.xml / build.gradle / go.mod / pyproject.toml, etc.}}`

```{{format}}
{{new dependency declarations — state purpose / version / feature flags}}
```

> Exact minor / patch versions are finalized against the §08 Step 1 lockfile / build results.

---

## 2. `{{module 1}}` ({{new/modified}})

### 2.1 Responsibilities

- {{responsibility 1}}
- {{responsibility 2}}

### 2.2 Structure

```{{language}}
{{key struct / class / trait / interface / function definitions}}
```

### 2.3 Concurrency / lifetime / security notes

- {{locking / synchronization — Mutex / RwLock / synchronized / sync.Mutex / asyncio.Lock, etc.}}
- {{keep await / async from crossing locks / isolate blocking I/O}}
- {{resource cleanup — Drop / dispose / try-with-resources / defer, etc.}}
- {{secret / sensitive data handling — secrecy / Sensitive / @Sensitive, etc.}}

---

## 3. `{{module 2}}` ({{new/modified}})

(repeat as needed — typically 5–12 modules)

---

## N. Change impact summary

| File / module                             | Change type | Essentials                                                                |
| :--------------------------------------- | :-------- | :------------------------------------------------------------------------ |
| `{{dependency manifest}}`                | Added     | {{new dependencies}}                                                      |
| `{{path}}`                               | New       | {{one-line essentials}}                                                   |
| `{{path}}`                               | Modified  | {{one-line essentials}}                                                   |
| `{{entry point}}`                        | Modified  | {{registration / routing / boot flow changes}}                            |

---

## N+1. Test guide (summary, re-organized per PR in §08)

- {{unit tests — model round-trips / resource cleanup / mapping functions / boundary values}}
- {{integration tests — wiremock / mock server / mock device / isolate external dependencies}}
- {{security / static verification — 0 hits on sensitive-data grep / dependency vulnerability scan}}

> Write verification commands for the project's build system: `cargo test` / `npm test` / `pytest` / `go test` / `mvn test` / `gradle test` / etc.
