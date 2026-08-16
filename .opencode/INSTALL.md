# OpenCode Integration for Cybersecurity Superpowers

## Overview

This guide explains how to install and activate the Cybersecurity Superpowers skills within [OpenCode](https://opencode.ai).

> **Prerequisites**: You must have OpenCode installed and configured. See the [OpenCode documentation](https://opencode.ai/docs) for setup instructions.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/rohit-barui/CyberSecurity-Superpowers.git
   cd CyberSecurity-Superpowers
   ```

2. Run the setup script to verify the environment:
   ```bash
   bash scripts/setup.sh
   ```

3. Configure OpenCode to recognize the skills. Add the following to your OpenCode configuration file (typically `~/.config/opencode/opencode.json` or project-local `.opencode/opencode.json`):

   ```json
   {
     "agents": {
       "cybersecurity-superpowers": {
         "path": "/path/to/CyberSecurity-Superpowers",
         "auto_load": true
       }
     }
   }
   ```

## Activating Skills

Skills are automatically discovered from the `skills/cybersecurity/` directory. OpenCode will load the following skills:

| Skill                | Description                                    |
|----------------------|------------------------------------------------|
| threat-modeling      | STRIDE-based threat analysis with CVSS scoring |
| secure-coding        | Language-specific OWASP security checklists    |
| static-analysis      | SAST and dependency vulnerability scanning     |
| penetration-testing  | Scoped red-team plan generation                |
| incident-response    | NIST-aligned incident response playbooks       |
| supply-chain-security | SBOM generation and supply chain scanning     |

## Available Scripts

| Script | Purpose |
|--------|---------|
| `scripts/run-orchestrator.sh` | Multi-skill pipeline with `implement`, `threat-model`, `full` modes |
| `scripts/run-security-suite.sh` | Batch runner for all 5 core skills |
| `scripts/setup.sh` | Environment verification |
| `scripts/init-project.sh` | Directory creation and hook installation |
| `scripts/generate-sbom.sh` | SBOM generation |
| `scripts/run-clear-eval.sh` | CLEAR framework project evaluation |

## Verification

To verify that skills are properly loaded:

```bash
opencode agent list
```

You should see `cybersecurity-superpowers` in the list of available agents.

## Uninstalling

Remove the agent configuration from your OpenCode config file, or delete this repository.

---

For full documentation, see the [main README](README.md).