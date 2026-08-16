---
name: secure-coding
description: "Applies language-specific OWASP secure-coding checklists, runs linting, and produces a SECURITY.md checklist."
---

# Secure Coding Skill

This skill helps you write secure code by applying language-specific OWASP secure coding checklists, running linting, and producing a SECURITY.md checklist.

## When to Use

You MUST use this skill during the implementation phase, for every code change, to ensure that security best practices are followed.

## Process Flow

1. **Identify the programming language** of the code being changed.
2. **Apply the corresponding OWASP secure coding checklist** for that language:
   - For JavaScript/Node.js: OWASP Node.js Goat and OWASP Top 10 for Node.js
   - For Python: OWASP Python Security Project
   - For Java: OWASP Java HTML Sanitizer Project and OWASP Top 10 for Java
   - For Go: OWASP Go Security Project
   - For Rust: OWASP Rust Security Guide
   - For C/C++: OWASP C/C++ Secure Coding
   - For C#: OWASP C# Secure Coding Guidelines
   - For PHP: OWASP PHP Security Project
   - For Ruby: OWASP Ruby Security Project
   - For Swift: OWASP iOS Security Project
   - For Kotlin: OWASP Android Security
3. **Run language-specific linters** and security scanners (e.g., ESLint with security plugins, Bandit for Python, etc.).
4. **Document any violations** and required fixes in a `SECURITY.md` file in the project root (or update if it exists).
5. **Provide remediation steps** for each violation found.

## Output

- Updated `SECURITY.md` file with:
  - List of secure coding rules applied
  - Any violations found
  - Remediation steps for each violation
  - Timestamp and version of the checklists used

## Examples

See `skills/cybersecurity/secure-coding/examples/` for sample SECURITY.md files.

## References

- OWASP Secure Coding Practices Quick Reference Guide
- OWASP Top Ten (2021)
- CWE/SANS Top 25 Most Dangerous Software Errors
- Language-specific OWASP projects (as listed above)