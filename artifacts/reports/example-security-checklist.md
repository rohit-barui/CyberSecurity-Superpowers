# Security Checklist - DemoApp

## Project: DemoApp
## Language: JavaScript
## Date: 2026-08-16

## Completed Checks

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Avoid `eval()` and similar dynamic code execution | **FAIL** | `eval()` used in `src/utils/parser.js:42` for template rendering |
| 2 | Use strict mode (`'use strict'`) | PASS | All modules use strict mode |
| 3 | Validate and sanitize all user input | **FAIL** | User input from search form is not sanitized before DB query |
| 4 | Prevent XSS by escaping output (use DOMPurify or similar) | **FAIL** | `innerHTML` assignment in `src/views/profile.js:15` without sanitization |
| 5 | Use parameterized queries to prevent SQL injection | **FAIL** | Raw string interpolation in `src/models/user.js:28` for SQL query |
| 6 | Set secure HTTP headers (CSP, HSTS, X-Frame-Options) | PASS | Helmet middleware configured correctly |
| 7 | Use HTTPS for all network communication | PASS | HTTPS enforced in production config |
| 8 | Avoid storing secrets in client-side code or localStorage | **FAIL** | API token stored in `localStorage` in `src/auth/client.js:10` |
| 9 | Use `Object.freeze()` on constant objects | PASS | Configuration objects are frozen |
| 10 | Audit npm dependencies for known vulnerabilities | **FAIL** | `lodash@4.17.20` has known prototype pollution vulnerability (CVE-2020-8203) |

## Violations Found

| # | Issue | Location | Severity | Remediation |
|---|-------|----------|----------|-------------|
| 1 | `eval()` used for template rendering | `src/utils/parser.js:42` | **CRITICAL** | Replace `eval()` with a safe templating engine (e.g., Handlebars, EJS) |
| 2 | Unsanitized user input in SQL query | `src/models/user.js:28` | **CRITICAL** | Replace string interpolation with parameterized queries using prepared statements |
| 3 | XSS via `innerHTML` assignment | `src/views/profile.js:15` | **HIGH** | Use `textContent` or DOMPurify.sanitize() before inserting user content |
| 4 | API token stored in localStorage | `src/auth/client.js:10` | **HIGH** | Use HttpOnly cookies instead of localStorage for authentication tokens |
| 5 | Vulnerable lodash dependency | `package.json` dependency | **MEDIUM** | Update lodash to >=4.17.21 with `npm update lodash` |

## Remediation Plan

1. **Critical - eval() removal**: Refactor `src/utils/parser.js` to use a safe templating library. Replace `eval('` + template + '`)' with Handlebars.compile().
2. **Critical - SQL injection**: Convert all raw SQL in `src/models/user.js` to use parameterized queries: `db.query('SELECT * FROM users WHERE id = ?', [userId])`.
3. **High - XSS**: In `src/views/profile.js`, replace `element.innerHTML = userInput` with `element.textContent = userInput` or `element.innerHTML = DOMPurify.sanitize(userInput)`.
4. **High - Token storage**: Move auth tokens from localStorage to HttpOnly, Secure, SameSite=Strict cookies via the backend response headers.
5. **Medium - Dependency audit**: Run `npm audit fix` and update lodash. Add `npm audit` to the CI pipeline to fail builds on HIGH/CRITICAL vulnerabilities.