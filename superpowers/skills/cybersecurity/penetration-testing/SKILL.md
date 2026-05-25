---
name: penetration-testing
description: "Produces a scoped red-team plan linked to MITRE ATT&CK and OWASP Web Security Testing Guide."
---

# Penetration Testing Skill

This skill helps you create a scoped red-team penetration testing plan for your application, linking test cases to the MITRE ATT&CK framework and the OWASP Web Security Testing Guide (WSTG).

## When to Use

You MUST use this skill after a release or on demand (e.g., before a major release, after significant changes, or when required by compliance) to validate the security of your application through simulated attacks.

## Process Flow

1. **Define the scope** of the penetration test:
   - Identify the assets to be tested (web applications, APIs, networks, etc.)
   - Define the boundaries (what is in-scope and what is out-of-scope)
   - Determine the testing methods (network, application, social engineering, etc.)
   - Establish the rules of engagement and legal boundaries.

2. **Gather information** (reconnaissance):
   - Passive: collect public information (DNS, SSL certificates, public repositories, etc.)
   - Active: scan for open ports, services, and technologies used (with permission).

3. **Identify potential threats and vulnerabilities** based on:
   - The attack surface identified in reconnaissance.
   - Common vulnerabilities in the technologies used (refer to CVE databases).
   - The threat model (if available) from the threat-modeling skill.

4. **Map test cases to frameworks**:
   - For each potential vulnerability, create a test case.
   - Link each test case to the relevant tactics and techniques in the MITRE ATT&CK framework (e.g., Initial Execution, Privilege Escalation, etc.).
   - For web applications, also link to the OWASP WSTG (e.g., WSTG-INPV-01 for input validation testing).

5. **Develop the test plan**:
   - Prioritize test cases based on risk (likelihood and impact).
   - Define the test environment and required tools.
   - Outline the step-by-step procedures for each test case.
   - Define the expected results and success/failure criteria.

6. **Document the plan** in a file named `PENTEST_PLAN.md` in the project root (or update if exists) that includes:
   - Scope and objectives
   - Rules of engagement
   - Reconnaissance findings
   - List of test cases with:
     - Test case ID
     - Description
     - MITRE ATT&CK tactic and technique
     - OWASP WSTG reference (if applicable)
     - Steps to execute
     - Expected results
     - Tools required
   - Resources and timeline
   - Reporting procedures

## Output

- `PENTEST_PLAN.md`: A detailed penetration testing plan that can be used by a security team or ethical hacker to test the application.

## Examples

See `skills/cybersecurity/penetration-testing/examples/` for sample PENTEST_PLAN.md files.

## References

- MITRE ATT&CK Framework (https://attack.mitre.org/)
- OWASP Web Security Testing Guide (WSTG) (https://owasp.org/www-project-web-security-testing-guide/)
- PTES (Penetration Testing Execution Standard)
- NIST SP 800-115 (Technical Guide to Information Security Testing)
- OWASP Testing Guide v4