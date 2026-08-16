# OWASP Secure Coding Checklist - JavaScript

- [ ] Avoid `eval()` and similar dynamic code execution
- [ ] Use strict mode (`'use strict'`)
- [ ] Validate and sanitize all user input
- [ ] Prevent XSS by escaping output (use DOMPurify or similar)
- [ ] Use parameterized queries to prevent SQL injection
- [ ] Set secure HTTP headers (CSP, HSTS, X-Frame-Options)
- [ ] Use HTTPS for all network communication
- [ ] Avoid storing secrets in client-side code or localStorage
- [ ] Use `Object.freeze()` on constant objects
- [ ] Audit npm dependencies for known vulnerabilities