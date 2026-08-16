# CyberSecurity Superpowers

A security-extension framework that embeds threat modeling, secure coding, static analysis, penetration testing, and incident response into any agentic development workflow. Route engineering tasks through a centralized orchestrator and automatically generate security artifacts at every stage of the SDLC.

[![CI](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml)
[![Release](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml)
[![Skills](https://img.shields.io/badge/skills-5-blue)](https://github.com/rohit-barui/CyberSecurity-Superpowers)
[![Version](https://img.shields.io/badge/version-0.1.0-blue)](https://github.com/rohit-barui/CyberSecurity-Superpowers)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## Quickstart

```bash
bash scripts/setup.sh
bash examples/demo-project/run-demo.sh
```

---

## Architecture

The system is built around a **ReAct orchestrator** that routes tasks to five specialized cybersecurity skill modules. Each skill adheres to a common interface — accepting structured input and producing markdown/JSON artifacts — and can be invoked independently or chained through the orchestrator.

```
Task → Orchestrator → [threat-modeling, secure-coding, static-analysis, penetration-testing, incident-response] → Artifacts
```

A **security-architecture** sub-skill produces C4 diagrams and Architecture Decision Records (ADRs) with embedded security context. The framework is harness-agnostic and runs identically under Claude Code, OpenCode, Cursor, Gemini CLI, Codex CLI, and GitHub Copilot CLI.

---

## Skill Reference

| Skill | Description | CLI Usage | Output |
|---|---|---|---|
| **threat-modeling** | STRIDE-based threat model with CVSS v3.1 scoring and OWASP/NIST mitigations | `bash skills/cybersecurity/threat-modeling/run.sh --project <name> --output-dir <dir>` | `THREAT_MODEL.md` |
| **secure-coding** | Language-specific OWASP checklist enforcement + linter integration | `bash skills/cybersecurity/secure-coding/run.sh --language <lang> --target-dir <dir> --output-dir <dir>` | `SECURITY.md` |
| **static-analysis** | SAST + dependency vulnerability scanning (npm audit, bandit, gosec, etc.) | `bash skills/cybersecurity/static-analysis/run.sh --target-dir <dir> --output-dir <dir>` | `SECURITY_SCAN.md` |
| **penetration-testing** | Scoped red-team plan linked to MITRE ATT&CK and OWASP WSTG | `bash skills/cybersecurity/penetration-testing/run.sh --project <name> --output-dir <dir>` | `PENTEST_PLAN.md` |
| **incident-response** | NIST SP 800-61 aligned playbook with checklists and comms templates | `bash skills/cybersecurity/incident-response/run.sh --project <name> --output-dir <dir>` | `INCIDENT_RESPONSE_PLAYBOOK.md` |

---

## Installation

**Prerequisites:** Bash 4+, Git, and at least one SAST tool (bandit, semgrep, npm audit, etc.).

```bash
git clone https://github.com/rohit-barui/CyberSecurity-Superpowers.git
cd CyberSecurity-Superpowers
bash scripts/setup.sh
```

`setup.sh` creates the required directory structure (`docs/adr`, `docs/architecture`, `tests/`, `artifacts/`) and installs git hooks from `hooks/pre-commit/` and `hooks/pre-push/`.

---

## Usage

### Orchestrator

Route a task by type:

```bash
bash scripts/run-orchestrator.sh design "Add user authentication"
bash scripts/run-orchestrator.sh implement "Write login endpoint"
bash scripts/run-orchestrator.sh validate "Run security tests"
bash scripts/run-orchestrator.sh operate "Handle data breach"
```

Task types: `design` → threat-modeling, `implement` → secure-coding + static-analysis, `validate` → penetration-testing, `operate` → incident-response.

### Individual Skills

Each skill can be invoked directly. See the **Skill Reference** table above for per-skill CLI flags.

### Git Hooks

Pre-commit hooks run secure-coding and static-analysis automatically; pre-push hooks enforce security gates (e.g., block on HIGH/CRITICAL SAST findings).

---

## CI/CD

The CI pipeline (`.github/workflows/`) runs three workflows on every push and pull request:

| Workflow | What It Does |
|---|---|
| **Lint** | ShellCheck on all shell scripts + YAML linting |
| **Security Scan** | Secret scanning (Gitleaks, TruffleHog), dependency auditing (`npm audit`), SAST (Bandit, Semgrep) with SARIF upload to GitHub CodeQL |
| **Skill Validation** | Verifies SKILL.md frontmatter and directory structure (checks for `templates/` and `references/` subdirectories) |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills, extending existing ones, and project conventions.

---

## License

MIT License — see [LICENSE](LICENSE) for full text.