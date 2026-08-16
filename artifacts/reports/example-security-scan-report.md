# Security Scan Report

## Project: my-node-app
## Date: 2026-08-16
## Tools Used: semgrep, bandit, npm-audit

## Summary

| Severity | Count |
|----------|-------|
| Critical | 2 |
| High | 4 |
| Medium | 3 |
| Low | 1 |
| Info | 0 |

## Findings

| ID | Tool | Type | Location | Severity | Description | Remediation |
|----|------|------|----------|----------|-------------|-------------|
| SA-001 | semgrep | sql-injection | src/db/query.js:42 | Critical | SQL injection via string concatenation in query builder. User-supplied input is directly concatenated into a SQL query string, allowing an attacker to manipulate the query. | Use parameterized queries or prepared statements. Replace `"SELECT * FROM users WHERE id = " + userId` with `db.query("SELECT * FROM users WHERE id = ?", [userId])`. |
| SA-007 | npm-audit | vulnerable-dep | package-lock.json | Critical | lodash prototype pollution (CVE-2023-1234). The lodash library version 4.17.20 is vulnerable to prototype pollution which can lead to remote code execution. | Update lodash to >=4.17.21: `npm install lodash@latest` |
| SA-002 | semgrep | hardcoded-secret | src/config/auth.js:15 | High | Hardcoded API secret found in source code. The JWT signing secret `"my-super-secret-key"` is hardcoded, making it accessible to anyone with source code access. | Move to environment variables or a vault. Use `process.env.JWT_SECRET` and set the secret in your deployment environment. |
| SA-003 | semgrep | xss | src/views/profile.jsx:88 | High | Reflected XSS via user input in template. User display name is rendered directly into innerHTML without sanitization. | Use output encoding or escape HTML entities. Replace `innerHTML` with `textContent` or use React's JSX auto-escaping. |
| SA-004 | bandit | hardcoded-password | src/auth.py:22 | High | Hardcoded password detected. Database password `"db_pass_123"` is hardcoded in the authentication module. | Use environment variable or secrets manager. Replace with `os.getenv("DB_PASSWORD")` and store the password securely. |
| SA-009 | semgrep | hardcoded-jwt | src/middleware/auth.js:30 | High | Hardcoded JWT signing secret. The JWT token is signed using a static string literal `"jwt_secret"` making tokens forgeable. | Use a strong, rotated secret from environment variables. Generate a random secret with `openssl rand -base64 32` and set it as `JWT_SECRET`. |
| SA-005 | bandit | eval-used | src/utils.py:55 | Medium | Use of eval() function detected. Dynamic code execution via `eval(user_input)` creates a code injection risk. | Replace with safe alternative such as `ast.literal_eval()` if parsing literals, or restructure logic to avoid dynamic evaluation. |
| SA-010 | gosec | weak-crypto | src/crypto/hash.go:8 | Medium | MD5 used for hashing passwords. MD5 is cryptographically broken and susceptible to collision attacks. | Use SHA-256 or stronger. Replace `md5.Sum()` with `sha256.Sum256()` and consider using bcrypt for password hashing. |
| SA-008 | semgrep | command-injection | src/exec/cmd.go:12 | Medium | Potential command injection via os/exec with user input. The `exec.Command("sh", "-c", userInput)` pattern allows shell injection. | Use safe argument passing and avoid shell invocation. Use `exec.Command("program", arg1, arg2)` instead of passing through a shell. |
| SA-006 | npm-audit | vulnerable-dep | package-lock.json | Low | minimist prototype pollution (CVE-2021-44906). The minimist package has a low-severity prototype pollution vulnerability that may affect argument parsing. | Update minimist to >=1.2.6: `npm install minimist@latest` |

## Tool Results

### npm audit

Found 2 known vulnerabilities:

| Package | Severity | CVE | Fix Available |
|---------|----------|-----|---------------|
| lodash | Critical | CVE-2023-1234 | 4.17.21 |
| minimist | Low | CVE-2021-44906 | 1.2.6 |

### Bandit

Ran bandit against all Python files. Found 2 issues:

| File | Line | Test | Severity |
|------|------|------|----------|
| src/auth.py | 22 | B105 | High |
| src/utils.py | 55 | B307 | Medium |

### Semgrep

Ran semgrep with custom security rules. Found 4 issues across JavaScript, TypeScript, and Go files.

## Next Steps

1. **IMMEDIATE** (Critical): Fix SQL injection in `src/db/query.js:42` using parameterized queries.
2. **IMMEDIATE** (Critical): Update lodash to patched version in package.json.
3. **HIGH PRIORITY**: Remove hardcoded secrets in `auth.js`, `auth.py`, and `middleware/auth.js`; move to environment variables.
4. **HIGH PRIORITY**: Fix reflected XSS in `profile.jsx:88` by using safe rendering.
5. **MEDIUM**: Refactor `eval()` usage in `utils.py` and replace MD5 hashing in `hash.go`.
6. **MEDIUM**: Fix command injection pattern in `cmd.go`.
7. **LOW**: Update minimist to patched version.