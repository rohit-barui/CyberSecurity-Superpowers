# CyberSecurity Superpowers — Demo Project

This is a demo project with **intentional security vulnerabilities** for testing the CyberSecurity Superpowers security suite.

## Vulnerabilities

1. **SQL Injection** (`app.js` — `GET /users`) — Raw user input is concatenated directly into a SQL query string without sanitization or parameterization.
2. **Hardcoded Secret** (`app.js` — `POST /api/data`) — An API secret key is hardcoded in source code (`sk-abc123def456ghi789jkl`) and used for request validation.
3. **Missing Security Headers** (`app.js` — `GET /`) — The Express app does not use helmet or set CSP, HSTS, X-Frame-Options, or X-Content-Type-Options headers.

## Running the Security Suite

```bash
# Run all security checks against this demo project
bash examples/demo-project/run-demo.sh
```

Or run individual skills:

```bash
# Threat modeling
bash skills/cybersecurity/threat-modeling/run.sh --project "Demo App" --output-dir artifacts/reports

# Secure coding review
bash skills/cybersecurity/secure-coding/run.sh --language javascript --target-dir examples/demo-project --output-dir artifacts/reports

# Static analysis (dry-run)
bash skills/cybersecurity/static-analysis/run.sh --target-dir examples/demo-project --output-dir artifacts/reports --dry-run
```