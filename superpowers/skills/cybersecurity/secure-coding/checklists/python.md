# OWASP Secure Coding Checklist - Python

- [ ] Use parameterized queries to prevent SQL injection
- [ ] Avoid `subprocess` with shell=True; use `shlex.quote()` if needed
- [ ] Use `defusedxml` for XML parsing to prevent XXE attacks
- [ ] Validate all input types and ranges
- [ ] Use `secrets` module for cryptographic tokens
- [ ] Avoid `pickle` for untrusted data
- [ ] Set secure cookies (HttpOnly, Secure, SameSite)
- [ ] Use `bandit` to scan for common security issues
- [ ] Pin dependency versions to prevent supply chain attacks
- [ ] Use environment variables for secrets, never hardcode