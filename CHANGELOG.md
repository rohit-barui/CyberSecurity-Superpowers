# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-08-16

### Added

- **PyPI Package**: Published `cybersec-superpowers` to PyPI. Install via `pip install cybersec-superpowers` or `pipx install cybersec-superpowers`.
- **Python CLI Wrapper**: `cybersec` CLI entry point (`src/cybersec_superpowers/cli.py`) wrapping all bash scripts — supports `threat-model`, `secure-code`, `static-analysis`, `pentest`, `incident-response`, `full`, `demo`, `sbom`, `setup` commands.
- **One-Click Installer**: `curl -sSL https://raw.githubusercontent.com/rohit-barui/CyberSecurity-Superpowers/main/install.sh | bash` — auto-detects OS, installs to `~/.cybersec-superpowers/`, adds to PATH.
- **Makefile**: Build, dev install, publish (test + prod), test, lint, demo, pipx-install targets.
- **Release Workflow**: Auto-publishes to PyPI on tag push via `pypa/gh-action-pypi-publish`. Also generates GitHub Release with archives + .whl assets.
- **GitHub About**: Repository description and 10 topics set.

### Fixed

- **Docs Audit**: 19 files corrected — critical issues incl. orchestrator arg passing, demo output filenames, marketing claims; 12 docs/skills high-priority fixes.
- **CI Pipeline**: shellcheck non-blocking, `chmod +x` per job, skill-tests path, build summary step.
- **License metadata**: Updated `pyproject.toml` to use SPDX expression format (fixes setuptools deprecation warnings).

## [0.1.0] - 2026-08-16

### Added

- **Threat-Modeling Skill**: STRIDE-based threat analysis with CVSS v3.1 scoring, MITRE ATT&CK mapping, and mitigation recommendations. Outputs `stride-model.md`.
- **Secure-Coding Skill**: OWASP security checklists for JavaScript, TypeScript, Python, Go, and Rust with automated language detection. Outputs `SECURITY.md`.
- **Static-Analysis Skill**: SAST and dependency vulnerability scanning with dry-run mock data support. Integrates semgrep, bandit, gosec, npm audit. Outputs `SECURITY_SCAN.md`.
- **Penetration-Testing Skill**: Scoped red-team plans with OWASP WSTG and MITRE ATT&CK mapping. Outputs `pentest-plan.md`.
- **Incident-Response Skill**: NIST SP 800-61 aligned playbooks for 5 incident types: ransomware, data-breach, phishing, ddos, insider-threat. Outputs `incident-playbook.md`.
- **Supply-Chain Security Skill**: SBOM generation in CycloneDX and SPDX formats with dependency vulnerability scanning via `scripts/generate-sbom.sh`.

### Added (Infrastructure)

- **Orchestrator**: Multi-skill pipeline runner with `implement`, `threat-model`, and `full` modes (`scripts/run-orchestrator.sh`).
- **Security Suite**: Batch runner executing all 5 skills sequentially with summary table (`scripts/run-security-suite.sh`).
- **Setup Script**: Environment verification and directory initialization (`scripts/setup.sh`).
- **Pre-commit Hooks**: Secret scanning (regex + gitleaks), dependency auditing (npm audit, pip-audit), static analysis (eslint, bandit, gosec).
- **Pre-push Hooks**: Threat model validation and compliance checks.
- **Tool Configurations**: Production-grade configs for semgrep (20+ rules), bandit, gosec, gitleaks (30+ secret patterns), and trivy.
- **Test Suite**: 5 skill-specific test scripts with mock fixtures, runnable via `bash tests/run-skill-tests.sh`.
- **CI Pipeline**: GitHub Actions with lint, skill-tests, orchestrator-demo, and build summary jobs.
- **Demo Project**: Node.js Express app at `examples/demo-project/` with 3 intentional vulnerabilities (SQL injection, hardcoded secret, missing security headers).
- **Architecture Documentation**: C4 context, container, and component diagrams, sequence diagrams, and 4 ADRs.
- **Community Files**: CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md, PR/issue templates, good-first-issues.
- **CLI Plugin**: Claude Code plugin manifest, OpenCode installation guide.

### Security

- All shell scripts use `set -euo pipefail` for strict error handling.
- Pre-commit hooks scan for accidental secret commits using gitleaks and regex patterns.
- Pre-push hooks validate threat models and check compliance before pushing.
- Dependency vulnerabilities scanned via automated CI pipeline.