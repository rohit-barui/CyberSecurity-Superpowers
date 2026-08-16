# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-08-16

### Added

- **Secure-Coding Skill**: Security checklists for Python, JavaScript/TypeScript, and C/C++ with automated scanning capabilities.
- **Static-Analysis Skill**: Source code analysis with multiple output formats including SARIF, JSON, and plain text. Supports configurable severity levels.
- **Incident-Response Skill**: Predefined playbooks and runbooks for incident types including phishing, data-breach, ransomware, and DDoS. Structured IR workflow from detection to post-mortem.
- **Compliance-Audit Skill**: Framework-aligned checklists for SOC 2, ISO 27001, PCI DSS, HIPAA, and GDPR with audit readiness scoring.
- **Threat-Intelligence Skill**: STIX/TAXII feed integration, IOC extraction, and threat scoring with MITRE ATT&CK mapping.

### Added (Infrastructure)

- **Orchestrator**: Multi-skill pipeline runner that chains analysis across all five skills and produces consolidated reports.
- **Pre-commit Hooks**: Automated security scanning (secrets detection, large file prevention) and code quality checks via pre-commit framework.
- **Test Suite**: Unit and integration tests organized by skill, runnable via `bash tests/run-skill-tests.sh`.
- **CI Pipeline**: GitHub Actions workflow for linting, testing, and validation on push and pull request.
- **Demo Project**: Reference project at `demo/` showcasing all skills with sample data and expected outputs.
- **Documentation**: Comprehensive README, setup guide, and per-skill SKILL.md files.

### Security

- All shell scripts use `set -euo pipefail` for strict error handling.
- Pre-commit hooks scan for accidental secret commits using `detect-secrets` and `gitleaks`.
- Dependency vulnerabilities scanned via automated CI pipeline.