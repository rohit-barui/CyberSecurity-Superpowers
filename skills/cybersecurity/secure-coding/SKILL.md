---
name: secure-coding
description: "Applies language-specific OWASP secure-coding checklists, runs linting, and produces a SECURITY.md checklist."
---

# Secure Coding Skill

This skill helps you write secure code by applying language-specific OWASP secure coding checklists, running linting, and producing a `SECURITY.md` checklist.

## Why Use This Skill

Writing functional code is not enough — modern applications must be resilient against SQL injections, cross-site scripting (XSS), insecure deserialization, and authentication bypasses.

- ⚡ **Language-Specific Guidance**: Tailored security checklists for JavaScript, TypeScript, Python, Go, and Rust.
- 🚫 **Prevent Common Pitfalls**: Automatically enforces OWASP Top 10 guidelines directly during the coding phase.
- 📜 **Audit Trail & Documentation**: Generates a version-controlled `SECURITY.md` checklist summarizing verified security controls.
- 🔄 **IDE & Agent Synergy**: Enables AI agents to audit code line-by-line before submitting pull requests.

## When to Use

You MUST use this skill during the implementation phase, for every code change, to ensure that security best practices are followed.

## Process Flow

1. **Identify the programming language** of the code being changed.
2. **Apply the corresponding OWASP secure coding checklist** for that language:
   - For JavaScript/Node.js: OWASP Node.js Goat and OWASP Top 10 for Node.js
   - For TypeScript: OWASP Node.js Goat and OWASP Top 10 for Node.js
   - For Python: OWASP Python Security Project
   - For Go: OWASP Go Security Project
   - For Rust: OWASP Rust Security Guide
3. **Run language-specific linters** and security scanners (e.g., ESLint with security plugins, Bandit for Python, etc.).
4. **Document any violations** and required fixes in a `SECURITY.md` file in the output directory (or update if it exists).
5. **Provide remediation steps** for each violation found.

## Supported Languages

Currently supported checklists: JavaScript, TypeScript, Python, Go, Rust. See `skills/cybersecurity/secure-coding/checklists/` for available files.

## Output

- `SECURITY.md` file with:
  - List of secure coding rules applied
  - Any violations found
  - Remediation steps for each violation
  - Timestamp and version of the checklists used

## CLI Usage

```bash
bash skills/cybersecurity/secure-coding/run.sh --language javascript --target-dir examples/demo-project --output-dir artifacts/reports
```

## References

- OWASP Secure Coding Practices Quick Reference Guide
- OWASP Top Ten (2021)
- CWE/SANS Top 25 Most Dangerous Software Errors
- Language-specific OWASP projects (as listed above)