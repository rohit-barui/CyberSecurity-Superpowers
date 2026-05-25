# Cybersecurity Superpowers Extension

This repository now includes a dedicated **Cybersecurity** skill set that augments the core Superpowers workflow with security‑focused capabilities. The new skills are designed to be automatically invoked where appropriate, ensuring security is baked into every stage of development.

## New Skills

| Skill | Description |
|------|-------------|
| **threat‑modeling** | Generates a STRIDE‑based threat model, assigns CVSS scores, and recommends mitigations (OWASP, NIST). |
| **secure‑coding** | Applies language‑specific OWASP secure‑coding checklists, runs linting, and produces a `SECURITY.md` checklist. |
| **static‑analysis** | Executes appropriate audit tools (`npm audit`, `bandit`, `gosec`, etc.) and creates a `SECURITY_SCAN.md` report with remediation steps. |
| **penetration‑testing** | Produces a scoped red‑team plan linked to MITRE ATT&CK and OWASP Web Security Testing Guide. |
| **incident‑response** | Generates a NIST‑aligned incident‑response playbook with checklists, communication templates, and lessons‑learned documentation. |

## How They Fit Into the Workflow
1. **brainstorming** → *threat‑modeling* (optional but recommended).
2. **writing‑plans** / *subagent‑driven‑development* → *secure‑coding* & *static‑analysis* run automatically on each code change.
3. After a release or on demand → *penetration‑testing* creates a testing plan.
4. When a vulnerability is confirmed → *incident‑response* produces a ready‑to‑use playbook.

## References & Standards
- OWASP Top 10 & language‑specific cheat sheets
- NIST SP 800‑30, 800‑53, 800‑61, 800‑115
- MITRE ATT&CK® Framework
- CIS Controls v8 (Controls 3, 4, 6, 8, 16, 19)
- PTES & OWASP Web Security Testing Guide

These skills are located under `skills/cybersecurity/` and are automatically discovered by the Superpowers engine. By adding them, agents now enforce security best practices throughout the entire software development lifecycle.
