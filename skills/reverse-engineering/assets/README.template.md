# `<project-name>`

> Template: copy this file to the new project root as `README.md`, fill in the `<...>` placeholders and each section, and delete this notice.
> The README is a **quick start + command catalog for users and contributors**. Permanent conventions and architecture belong to [`docs/`](docs/00.INDEX.md); AI collaboration rules belong to [`.claude/CLAUDE.md`](.claude/CLAUDE.md).

`<one-line intro>` — `<1–2 sentences on what the project does>`.

---

## 1. Project Introduction

`<Project overview, 3–5 bullets of key features>`

- `<feature 1>`
- `<feature 2>`

> For detailed architecture and domain conventions see [`docs/00.INDEX.md`](docs/00.INDEX.md).

---

## 2. Tech Stack

| Category | Technology |
| :--- | :--- |
| Language | `<language>` |
| Framework / Runtime | `<framework>` |
| Package Manager | `<package-manager>` |
| Testing | `<test-framework>` |
| Lint · Format | `<lint-tool>` |
| Build | `<build-tool>` |

---

## 3. Prerequisites

- `<runtime>` `<version>` or later (e.g. Node 20 / JDK 21 / Python 3.12 / Rust 1.80)
- `<package-manager>` `<version>`
- `<other OS tools/SDKs>` _(if applicable)_

---

## 4. Getting Started

### 4.1 Install Dependencies

```bash
<install-cmd>      # e.g. pnpm install / poetry install / ./gradlew build
```

### 4.2 Prepare Environment Files _(if applicable)_

```bash
cp <env-example> <env-file>    # e.g. cp .env.example .env  (native Windows: Copy-Item .env.example .env)
```

| Key | Description | Example |
| :--- | :--- | :--- |
| `<KEY>` | `<description>` | `<value>` |

---

## 5. Run

```bash
<dev-cmd>          # Run dev server / app (e.g. pnpm dev / mvn spring-boot:run)
```

---

## 6. Verify / Build

| Step | Command |
| :--- | :--- |
| Type check | `<typecheck-cmd>` |
| Lint | `<lint-cmd>` |
| Test | `<test-cmd>` |
| Format | `<format-cmd>` |
| Build | `<build-cmd>` |

> For verification pipeline details, CI entry points, and test conventions see [`docs/10.build-ops-guide.md`](docs/10.build-ops-guide.md).

---

## 7. Project Structure (Summary)

```text
<root>/
├─ <src>/            # Source
├─ docs/             # Permanent guides (see 00.INDEX)
├─ .claude/          # AI collaboration rules, design documents
└─ <build-config>    # Build configuration
```

> For the full structure and feature rules see [`docs/09.project-guide.md`](docs/09.project-guide.md) §Current Structure.

---

## 8. Recommended Development Tools

- IDE: `<IDE>` (e.g. VS Code / IntelliJ / Android Studio)
- Recommended extensions / plugins: `<extensions>`

---

## 9. Documentation

| Kind | Location |
| :--- | :--- |
| Document index (start here) | [`docs/00.INDEX.md`](docs/00.INDEX.md) |
| Domain / architecture guides | [`docs/`](docs/) (permanent guides) |
| Progress / roadmap | [`docs/13.roadmap.md`](docs/13.roadmap.md) |
| AI collaboration rules | [`.claude/CLAUDE.md`](.claude/CLAUDE.md) |

---

## 10. Troubleshooting

| Symptom | Cause | Resolution |
| :--- | :--- | :--- |
| `<symptom>` | `<cause>` | `<resolution>` |

> For runtime logs and incident response see [`docs/10.build-ops-guide.md`](docs/10.build-ops-guide.md) §Operations/Logs; for project-specific errors see [`docs/09.project-guide.md`](docs/09.project-guide.md) §Troubleshooting.

---

## 11. License / Contributing _(optional)_

- License: `<license>`
- Contribution guide: `<CONTRIBUTING link or process>`
