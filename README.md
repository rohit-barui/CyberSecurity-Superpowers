# 🛡️ CyberSecurity Superpowers

> **The Ultimate Enterprise DevSecOps & Cybersecurity Extension for AI Coding Agents.**
> Embed automated threat modeling, secure coding, SAST scanning, red-team penetration testing, NIST incident response, and supply-chain security into any agentic workflow.

[![CI Pipeline](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/ci.yml)
[![Release](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml/badge.svg)](https://github.com/rohit-barui/CyberSecurity-Superpowers/actions/workflows/release.yml)
[![Skills](https://img.shields.io/badge/superpowers-6_core_skills-007ACC?style=flat-square&logo=shield)](https://github.com/rohit-barui/CyberSecurity-Superpowers)
[![Version](https://img.shields.io/badge/version-v0.1.0-brightgreen?style=flat-square)](https://github.com/rohit-barui/CyberSecurity-Superpowers/releases)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Standards](https://img.shields.io/badge/standards-OWASP_|_NIST_|_MITRE_ATT%26CK-orange?style=flat-square)](https://github.com/rohit-barui/CyberSecurity-Superpowers)

---

## ⚡ Why CyberSecurity Superpowers is THE Go-To Skill Set

AI coding assistants are faster than ever at writing code — but speed without security creates vulnerabilities at scale. **CyberSecurity Superpowers** transforms any AI assistant (Claude Code, Gemini CLI, Cursor, OpenCode, Copilot) into an autonomous **CISO-grade DevSecOps engineer**.

### 🌟 Key Differentiators & Benefits

* 🎯 **360° SDLC Security Coverage**: From pre-code threat modeling to post-breach incident playbooks, cover every phase of security automatically.
* 🤖 **Autonomous ReAct Orchestrator**: Intelligently routes tasks to specific security skill modules without manual intervention.
* 🏆 **Industry-Standard Alignment**: Native integration with **OWASP Top 10**, **OWASP WSTG**, **MITRE ATT&CK**, **NIST SP 800-61**, **CVSS v3.1**, and **CycloneDX/SPDX**.
* 🌐 **Harness-Agnostic & Zero Lock-in**: Works out of the box with any LLM, CLI, or agent runtime on Linux, macOS, and Windows.
* 📊 **Audit-Ready Artifact Generation**: Automatically generates structured, version-controlled Markdown & JSON reports in `artifacts/reports/`.

---

## 🚀 Quickstart

Get up and running in 30 seconds:

```bash
# Clone the repository
git clone https://github.com/rohit-barui/CyberSecurity-Superpowers.git
cd CyberSecurity-Superpowers

# Initialize workspace & verify environment
bash scripts/setup.sh

# Run the end-to-end security demo
bash examples/demo-project/run-demo.sh
```

---

## 🧩 The 6 Core Cybersecurity Superpowers

| Superpower | Description | Industry Standard | Output Artifact |
|---|---|---|---|
| 🧠 **Threat Modeling** | Automated STRIDE threat analysis, trust boundary mapping, & CVSS v3.1 risk scoring | NIST SP 800-53 / OWASP ASVS | `artifacts/reports/stride-model.md` |
| 🛡️ **Secure Coding** | Language-specific security checklist enforcement (JS, TS, Python, Go, Rust) | OWASP Top 10 | `artifacts/reports/SECURITY.md` |
| 🔍 **Static Analysis (SAST)** | Multi-engine SAST & dependency vulnerability scanning (Semgrep, Bandit, Gosec, NPM Audit) | SARIF / CWE / CVE | `artifacts/reports/SECURITY_SCAN.md` |
| ⚔️ **Penetration Testing** | Scoped red-team attack plan generator mapped to offensive tactics | MITRE ATT&CK & OWASP WSTG | `artifacts/reports/pentest-plan.md` |
| 🚨 **Incident Response** | Incident playbook generator for Ransomware, Data Breach, Phishing, DDoS, & Insider Threats | NIST SP 800-61 Rev. 2 | `artifacts/reports/incident-playbook.md` |
| 📦 **Supply-Chain Security** | Automated SBOM generation (CycloneDX / SPDX) and dependency vulnerability audit | NTIA Minimum Elements | `artifacts/sbom/sbom-report.json` |

---

## 🏗️ Architecture & Orchestration

The system utilizes an autonomous **ReAct Orchestrator** (`scripts/run-orchestrator.sh`) that accepts natural language intent or CLI modes and routes them across the underlying security modules:

```
                  ┌───────────────────────────────┐
                  │    User / AI Agent Intent     │
                  └───────────────┬───────────────┘
                                  │
                                  ▼
                  ┌───────────────────────────────┐
                  │      ReAct Orchestrator       │
                  │   (scripts/run-orchestrator)  │
                  └───────────────┬───────────────┘
                                  │
      ┌───────────────┬───────────┼───────────┬───────────────┐
      ▼               ▼           ▼           ▼               ▼
┌───────────┐   ┌───────────┐ ┌───────────┐ ┌───────────┐   ┌───────────┐
│  Threat   │   │  Secure   │ │  Static   │ │   Pentest │   │ Incident  │
│ Modeling  │   │  Coding   │ │ Analysis  │ │   Plan    │   │ Response  │
└─────┬─────┘   └─────┬─────┘ └─────┬─────┘ └─────┬─────┘   └─────┬─────┘
      │               │           │           │               │
      └───────────────┴───────────┼───────────┴───────────────┘
                                  │
                                  ▼
                  ┌───────────────────────────────┐
                  │ Audit-Ready Markdown & JSON   │
                  │ (artifacts/reports/*.md)      │
                  └───────────────────────────────┘
```

---

## 💻 Usage & CLI Examples

### Automated Orchestration

```bash
# Run Secure Coding + SAST on current codebase
bash scripts/run-orchestrator.sh implement "Authentication microservice"

# Generate complete Threat Model for a project
bash scripts/run-orchestrator.sh threat-model "Payment Gateway API"

# Run full 5-phase security suite
bash scripts/run-orchestrator.sh full "Production Release Candidate"
```

### Direct Skill Execution

```bash
# Threat Modeling
bash skills/cybersecurity/threat-modeling/run.sh --project "E-Commerce System"

# Secure Coding Checklists
bash skills/cybersecurity/secure-coding/run.sh --language python --target-dir ./src

# Static Analysis (SAST)
bash skills/cybersecurity/static-analysis/run.sh --target-dir ./src --format md

# Penetration Testing Plan
bash skills/cybersecurity/penetration-testing/run.sh --target-app "Portal API" --scope web

# Incident Response Playbook
bash skills/cybersecurity/incident-response/run.sh --incident-type ransomware

# Supply Chain SBOM Generation
bash scripts/generate-sbom.sh --target-dir .
```

### Git Hooks & DevSecOps Automation

Protect your main branch automatically before commits and pushes:

```bash
# Install automated Git hooks (Pre-commit SAST & Pre-push security gates)
bash scripts/init-project.sh
```

---

## 🛡️ CI/CD Pipeline

Every commit and pull request is automatically validated by GitHub Actions (`.github/workflows/ci.yml`):

* ✅ **Lint & Frontmatter Validation**: ShellCheck, Yamllint, and `SKILL.md` spec validation.
* ✅ **Automated Skill Tests**: End-to-end unit test execution across all 6 superpowers (`tests/run-skill-tests.sh`).
* ✅ **Orchestrator Verification**: Live execution check of the orchestrator pipeline.
* ✅ **Security Gate Build**: Summary matrix validation with non-zero exit enforcement on failure.

---

## 👥 Contributing

We welcome community contributions! Check out our [Good First Issues](docs/good-first-issues.md) and review [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE). Feel free to use, adapt, and build upon it!

---

*Built with ❤️ for the AI Security & DevSecOps Community.*