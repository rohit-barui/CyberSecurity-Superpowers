# CyberSecurity Superpowers

A security-extension framework that embeds threat modeling, secure coding, static analysis, penetration testing, incident response, and supply-chain security into any agentic development workflow. Route engineering tasks through a centralized orchestrator and automatically generate security artifacts at every stage of the SDLC.

[![CI](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml)
[![Release](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml)
[![Skills](https://img.shields.io/badge/skills-6-blue)](https://github.com/rohit-barui/CyberSecurity-Superpowers)
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

The system is built around a **ReAct orchestrator** that routes tasks to six specialized cybersecurity skill modules. Each skill adheres to a common interface — accepting structured input and producing markdown/JSON artifacts — and can be invoked independently or chained through the orchestrator.

```
Task → Orchestrator → [threat-modeling, secure-coding, static-analysis, penetration-testing, incident-response] → Artifacts
```

Supply-chain security (SBOM generation) is available via `scripts/generate-sbom.sh`. The framework is harness-agnostic and runs identically under Claude Code, OpenCode, Cursor, Gemini CLI, Codex CLI, and GitHub Copilot CLI.

---

## Skill Reference

| Skill | Description | CLI Usage | Output |
|---|---|---|---|
| **threat-modeling** | STRIDE-based threat model with CVSS v3.1 scoring and OWASP/NIST mitigations | `bash skills/cybersecurity/threat-modeling/run.sh --project <name> --output-dir <dir>` | `stride-model.md` |
| **secure-coding** | Language-specific OWASP checklist enforcement (JS/TS/Python/Go/Rust) | `bash skills/cybersecurity/secure-coding/run.sh --language <lang> --target-dir <dir> --output-dir <dir>` | `SECURITY.md` |
| **static-analysis** | SAST + dependency vulnerability scanning (semgrep, bandit, gosec, npm audit) | `bash skills/cybersecurity/static-analysis/run.sh --target-dir <dir> --output-dir <dir>` | `SECURITY_SCAN.md` |
| **penetration-testing** | Scoped red-team plan linked to MITRE ATT&CK and OWASP WSTG | `bash skills/cybersecurity/penetration-testing/run.sh --target-app <name> --output-dir <dir>` | `pentest-plan.md` |
| **incident-response** | NIST SP 800-61 aligned playbook with 5 incident types | `bash skills/cybersecurity/incident-response/run.sh --incident-type <type> --output-dir <dir>` | `incident-playbook.md` |
| **supply-chain-security** | SBOM generation (CycloneDX/SPDX) and dependency vulnerability scanning | `bash scripts/generate-sbom.sh --target-dir <dir> --output-dir <dir>` | `sbom-report.json` |

---

## Installation

**Prerequisites:** Bash 4+, Git, and at least one SAST tool (bandit, semgrep, npm audit, etc.).

```bash
git clone https://github.com/rohit-barui/CyberSecurity-Superpowers.git
cd CyberSecurity-Superpowers
bash scripts/setup.sh
```

`setup.sh` verifies the directory structure, checks tool availability, and initializes `artifacts/reports/` and `artifacts/sbom/`. For hook installation, run `bash scripts/init-project.sh`.

---

## Usage

### Orchestrator

Route a task by type:

```bash
bash scripts/run-orchestrator.sh implement "Add login endpoint"
bash scripts/run-orchestrator.sh threat-model "User authentication system"
bash scripts/run-orchestrator.sh full "Complete security review"
```

Modes: `implement` → secure-coding + static-analysis, `threat-model` → threat-modeling, `full` → all 5 skills.

### Individual Skills

Each skill can be invoked directly. See the **Skill Reference** table above for per-skill CLI flags.

### Git Hooks

Pre-commit hooks run secret scanning, dependency auditing, and static analysis automatically; pre-push hooks enforce security gates (validate threat models, check compliance). Install via `bash scripts/init-project.sh`.

---

## CI/CD

The CI pipeline (`.github/workflows/ci.yml`) runs on every push and pull request to main:

| Job | What It Does |
|---|---|
| **lint** | ShellCheck, YAML linting, SKILL.md frontmatter validation |
| **skill-tests** | Full test suite via `bash tests/run-skill-tests.sh` |
| **orchestrator-demo** | Runs orchestrator threat-model mode and verifies output |
| **build** | Consolidates results — fails if any upstream job fails |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills, extending existing ones, and project conventions.

---

## License

MIT License — see [LICENSE](LICENSE) for full text.