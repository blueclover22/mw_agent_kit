# Security Audit Checklist

> Editions: OWASP Top 10:2025 · OWASP API Security Top 10:2023 · OWASP Top 10 for LLM Applications 2025
> Top 10:2025 names verified 2026-11-11 against top10.owasp.org
> Grep hints are language-neutral starting points, not proof — Read the surrounding code before recording a finding.

---

## Core — OWASP Top 10:2025 (always)

| ID | Item | Look for | Grep hints |
| :--- | :--- | :--- | :--- |
| A01 | Broken Access Control (SSRF merged here) | Handlers missing authorization checks; object IDs taken from the request without an ownership check; server-side fetch of a user-supplied URL; path traversal on file access | `req.params`, `request.args`, `@PathVariable`, `fetch(`/`requests.get(`/`http.Get(` with request input, `../`, `sendFile`, `open(` with request input |
| A02 | Security Misconfiguration | Debug mode in production config; wildcard CORS with credentials; default credentials; verbose error pages; missing security headers | `DEBUG = True`, `debug: true`, `Access-Control-Allow-Origin: *`, `origin: '*'`, `admin:admin`, `stackTrace`, `helmet` absent |
| A03 | Software Supply Chain Failures | No lockfile; unpinned or wildcard versions; dependencies from untrusted registries or git URLs; install scripts; known-vulnerable versions (see Dependencies module) | `"*"`, `"latest"`, `git+`, `postinstall`, `--extra-index-url`, `curl … \| sh` |
| A04 | Cryptographic Failures | Weak hashes for passwords; hard-coded or reused keys/IVs; TLS verification disabled; sensitive data stored or sent in plaintext | `md5`, `sha1`, `DES`, `ECB`, `verify=False`, `rejectUnauthorized: false`, `InsecureSkipVerify`, `http://`, `Math.random` for tokens |
| A05 | Injection | String-built SQL/NoSQL/LDAP queries; shell commands with user input; dynamic code evaluation; unescaped output (XSS); unsafe deserialization | `"SELECT … " +`, `f"SELECT`, `${` inside SQL, `exec(`, `eval(`, `child_process`, `shell=True`, `os.system`, `innerHTML`, `dangerouslySetInnerHTML`, `pickle.loads`, `yaml.load(` |
| A06 | Insecure Design | No rate limit or lockout on sensitive flows; trust in client-side checks; missing threat boundaries (tenant isolation, workflow step order) | `login`, `reset`, `otp`, `checkout` handlers without limiter; validation only in frontend code |
| A07 | Authentication Failures | Plaintext or weakly hashed passwords; JWT without signature/expiry checks; session fixation; no MFA path for privileged users; credentials in URLs | `alg: none`, `jwt.decode(` without verify, `verify_signature: False`, `expiresIn` absent, `password ==`, `?token=` |
| A08 | Software or Data Integrity Failures | Unsigned updates or artifacts; deserializing untrusted data; CI pipelines pulling unpinned actions or scripts; trusting unsigned cookies/tokens | `pickle`, `ObjectInputStream`, `unserialize(`, `uses: …@master`, `curl … \| bash`, unsigned cookie parsing |
| A09 | Security Logging & Alerting Failures | Auth failures and access denials not logged; secrets or PII written to logs; logs open to injection; no alerting hook | `console.log(password`, `logger.info(token`, logging request bodies, empty `catch` around auth |
| A10 | Mishandling of Exceptional Conditions | Fail-open error handling (catch → allow); swallowed exceptions; error messages leaking internals; unchecked return values; resource leaks on error paths | `catch (e) {}`, `except: pass`, `catch … return true`, `rescue nil`, `_ = err`, `res.send(err)`, `e.printStackTrace` |

---

## Modules

### Secrets (always)

| ID | Look for | Grep hints |
| :--- | :--- | :--- |
| SEC-1 | Hardcoded API keys, tokens, passwords in source or config | `api_key`, `apikey`, `secret`, `token =`, `password =`, `sk_live_`, `sk_test_`, `AKIA`, `ghp_`, `xox[bp]-`, `AIza` |
| SEC-2 | Committed environment files | `.env`, `.env.*` tracked (not only `.env.example`); `.gitignore` missing `.env` |
| SEC-3 | Private keys and credentials files | `-----BEGIN .*PRIVATE KEY-----`, `*.pem`, `*.p12`, `id_rsa`, `credentials.json` |

### Dependencies (when a manifest or lockfile exists)

| ID | Look for |
| :--- | :--- |
| DEP-1 | A lockfile is present and committed for each manifest |
| DEP-2 | Versions are pinned or range-bounded; no `*` / `latest` / git-branch references |
| DEP-3 | Known-vulnerable versions — run the ecosystem scanner from the Scanner map; if none is installed, mark `Not checked` |

### IaC / Containers (Dockerfile, compose, k8s manifests, terraform present)

| ID | Look for | Grep hints |
| :--- | :--- | :--- |
| IAC-1 | Container runs as root | Dockerfile without `USER`, `runAsNonRoot: false`, `runAsUser: 0` |
| IAC-2 | Mutable image tags | `:latest`, `FROM` without a tag or digest |
| IAC-3 | Privileged or host-level access | `privileged: true`, `hostNetwork: true`, `hostPath`, `/var/run/docker.sock`, `cap_add` |
| IAC-4 | Public storage and open network rules | `acl = "public-read"`, `block_public_acls = false`, `0.0.0.0/0`, `::/0` |
| IAC-5 | Secrets baked into images or manifests | `ENV …KEY=`, `ARG …PASSWORD`, plaintext `Secret` data in git |

### OWASP API Security Top 10:2023 (when the project serves an HTTP API)

| ID | Item | Look for |
| :--- | :--- | :--- |
| API1 | Broken Object Level Authorization | Object IDs from path/query used without an ownership check |
| API2 | Broken Authentication | Unauthenticated endpoints that should not be; weak token validation |
| API3 | Broken Object Property Level Authorization | Mass assignment (whole request body bound to a model); responses returning internal fields |
| API4 | Unrestricted Resource Consumption | No rate limit, pagination cap, or request size limit |
| API5 | Broken Function Level Authorization | Admin routes guarded only by obscurity or a client-side flag |
| API6 | Unrestricted Access to Sensitive Business Flows | Purchase/signup/voting flows with no anti-automation control |
| API7 | Server Side Request Forgery | Server fetches a user-supplied URL without an allowlist |
| API8 | Security Misconfiguration | Wildcard CORS, verbose errors, unused HTTP methods enabled |
| API9 | Improper Inventory Management | Old API versions or debug endpoints still routed; spec out of sync with routes |
| API10 | Unsafe Consumption of APIs | Third-party API responses trusted without validation; TLS checks disabled for upstreams |

### OWASP Top 10 for LLM Applications 2025 (when an LLM SDK or API is used)

| ID | Item | Look for |
| :--- | :--- | :--- |
| LLM01 | Prompt Injection | User or retrieved content concatenated into system/tool prompts without separation |
| LLM02 | Sensitive Information Disclosure | Secrets or PII placed in prompts, logs, or training data |
| LLM03 | Supply Chain | Unpinned model or adapter downloads; models from unverified sources |
| LLM04 | Data and Model Poisoning | Untrusted data flowing into fine-tuning or retrieval indexes without review |
| LLM05 | Improper Output Handling | Model output passed to `eval(`, shell, SQL, or HTML without validation |
| LLM06 | Excessive Agency | Tools granted broad write/exec permissions; no human approval on destructive actions |
| LLM07 | System Prompt Leakage | Credentials or access rules embedded in the system prompt |
| LLM08 | Vector and Embedding Weaknesses | Retrieval without per-tenant access filtering |
| LLM09 | Misinformation | Model output presented as authoritative with no grounding or review path |
| LLM10 | Unbounded Consumption | No token, request, or cost limits on model calls |

---

## Scanner map

Detect with `command -v <tool>`. Run only installed tools, read-only. Never install a missing one — record it as not installed.

| Tool | Ecosystem / module | Read-only invocation | Note |
| :--- | :--- | :--- | :--- |
| npm / pnpm / yarn audit | Node — DEP-3 | `npm audit` / `pnpm audit` / `yarn npm audit` (Yarn 2+) / `yarn audit` (Yarn 1) | Queries the registry advisory API (network) |
| pip-audit | Python — DEP-3 | `pip-audit -r requirements.txt --no-deps --disable-pip` | Queries an advisory DB (network). Needs fully pinned requirements; without `--disable-pip` it installs packages into a temporary venv (runs package build code) — needs approval |
| govulncheck | Go — DEP-3 | `govulncheck ./...` | Queries vuln.go.dev (network) |
| cargo audit | Rust — DEP-3 | `cargo audit` | Fetches the advisory DB (network) |
| osv-scanner | Multi-ecosystem — DEP-3 | `osv-scanner scan source -r .` | Queries osv.dev (network) |
| gitleaks | Secrets | `gitleaks dir . --redact -v` (older versions: `gitleaks detect --no-git --redact -v`) | Always pass `--redact` |
| trufflehog | Secrets | `trufflehog filesystem . --no-verification` | Always pass `--no-verification` — without it, found credentials are sent to provider APIs for live checks |
| trivy | Dependencies, IaC/Containers | `trivy fs .` / `trivy config .` | Downloads its DB on first run (network) |
| semgrep | Core A01–A10 | `semgrep scan --config auto` | `--config auto` fetches rules from the network — needs approval |
| checkov | IaC | `checkov -d .` | Local rules |
| hadolint | Dockerfile | `hadolint Dockerfile` | Local rules |

Tools marked "network" only download or query an advisory database — they do not scan remote hosts, so they may run in the invocation shown. A command marked "needs approval" (`semgrep --config auto`, `pip-audit` without `--disable-pip`) runs only when the invocation arguments grant it; otherwise record `⚠️ skipped — needs approval`.
