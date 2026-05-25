---
name: static-analysis
description: "Executes appropriate audit tools (`npm audit`, `bandit`, `gosec`, etc.) and creates a `SECURITY_SCAN.md` report with remediation steps."
---

# Static Analysis Skill

This skill helps you perform static analysis security testing (SAST) and dependency scanning on your project, then generates a report with remediation steps.

## When to Use

You MUST use this skill during the implementation phase, after code changes are made but before requesting code review, to catch security vulnerabilities early.

## Process Flow

1. **Identify the project type** and dependencies:
   - For JavaScript/Node.js: check for `package.json` or `yarn.lock`
   - For Python: check for `requirements.txt`, `setup.py`, `Pipfile`, or `pyproject.toml`
   - For Go: check for `go.mod`
   - For Rust: check for `Cargo.toml`
   - For Java: check for `pom.xml` or `build.gradle`
   - For .NET: check for `.csproj` or `packages.config`
   - For PHP: check for `composer.json`
   - For Ruby: check for `Gemfile`
   - For Swift: check for `Package.swift`
   - For Kotlin: check for `build.gradle.kts` or `pom.xml`

2. **Run the appropriate tools**:
   - **Dependency Scanning**:
     - JavaScript/Node.js: `npm audit` or `yarn audit`
     - Python: `pip-audit` or `safety check`
     - Go: `govulncheck` (if available) or manual review
     - Rust: `cargo audit`
     - Java: `dependency-check` or `OWASP Dependency-Check`
     - .NET: `dotnet list package --vulnerable` or `OWASP Dependency-Check`
     - PHP: `composer audit` (if available) or `security-checker`
     - Ruby: `bundler-audit`
     - Swift: `swift-security-scan` (if available) or manual review
     - Kotlin: same as Java or Gradle-specific tools
   - **SAST (Static Application Security Testing)**:
     - Use language-appropriate tools:
       - JavaScript/TypeScript: `ESLint` with security plugins (e.g., `eslint-plugin-security`) or `CodeQL`
       - Python: `Bandit`
       - Go: `Gosec`
       - Java: `SpotBugs` with security plugins or `CodeQL`
       - .NET: `Security Code Scan` or `CodeQL`
       - PHP: `PHPStan` with security rules or `CodeQL`
       - Ruby: `Brakeman` or `CodeQL`
       - Swift: `SwiftLint` with security rules or `CodeQL`
       - Kotlin: `Detekt` with security rules or `CodeQL`
       - C/C++: `CPPCheck` or `CodeQL`
       - Also consider using `Semgrep` for multi-language support if configured.

3. **Collect and normalize results** from all tools into a common format.

4. **Generate a report** in `SECURITY_SCAN.md` in the project root (or update if exists) that includes:
   - Summary of findings (counts by severity: Critical, High, Medium, Low, Info)
   - For each finding:
     - Tool that found it
     - Type of issue (vulnerability, weakness, etc.)
     - Location (file, line, function, etc.)
     - Description
     - Severity (with CVSS score if available)
     - Remediation steps
     - References (CVE, CWE, etc.)

5. **Provide remediation guidance** for each finding, prioritized by severity.

## Output

- `SECURITY_SCAN.md`: Contains the static analysis and dependency scan results with remediation steps.
- If the project already has a `SECURITY.md`, consider updating it with any new security requirements discovered.

## Examples

See `skills/cybersecurity/static-analysis/examples/` for sample SECURITY_SCAN.md files.

## References

- OWASP Testing Guide v4 (SAST and Dependency Checking)
- NIST SP 800-115 (Technical Guide to Information Security Testing)
- Specific tool documentation (as listed above)
- CVE and CWE databases