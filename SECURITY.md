# Security Policy

## Overview

Cybersecurity Superpowers is a community-driven project. We take security seriously and appreciate the community's help in disclosing vulnerabilities responsibly.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it by emailing the project maintainer with the following template:

**Subject**: [Cybersecurity Superpowers] Security Vulnerability Report

**Body**:
```
- Project version: <version>
- Vulnerability type: <e.g., XSS, RCE, privilege escalation>
- Description: <detailed description>
- Steps to reproduce: <detailed steps>
- Affected files/components: <list>
- Potential impact: <what an attacker could do>
- Suggested fix (if any): <optional>
```

**Response Timeline**:
- **Initial acknowledgment**: Within 48 hours
- **Status update**: Within 5 business days
- **Expected fix timeline**: Within 30 days for confirmed vulnerabilities

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

Only the latest major version receives security patches.

## Security Practices

- All shell scripts use `set -euo pipefail` for fail-fast behavior.
- Pre-commit hooks scan for secrets and credentials before commits.
- Dependency scanning is part of the CI pipeline.
- Input validation is enforced at script boundaries.
- Principle of least privilege is followed in all tooling.

## Bug Bounty

We do not currently operate a bug bounty program. However, we welcome responsible disclosure and will publicly acknowledge valid security reports (with the reporter's consent) in our release notes.