# OpenCode Integration for Cybersecurity Superpowers

## Overview

This guide explains how to install and activate the Cybersecurity Superpowers skills within [OpenCode](https://opencode.ai).

> **Prerequisites**: You must have OpenCode installed and configured. See the [OpenCode documentation](https://opencode.ai/docs) for setup instructions.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/rohit-barui/cybersecurity-superpowers.git
   cd cybersecurity-superpowers
   ```

2. Run the setup script to install all dependencies and pre-commit hooks:
   ```bash
   bash scripts/setup.sh
   ```

3. Configure OpenCode to recognize the skills. Add the following to your OpenCode configuration file (typically `~/.config/opencode/opencode.json` or project-local `.opencode/opencode.json`):

   ```json
   {
     "agents": {
       "cybersecurity-superpowers": {
         "path": "/path/to/cybersecurity-superpowers",
         "auto_load": true
       }
     }
   }
   ```

## Activating Skills

Skills are automatically discovered from the `skills/` directory. OpenCode will load the following skills:

| Skill                | Description                                    |
|----------------------|------------------------------------------------|
| secure-coding        | Security checklists and code review guidance   |
| static-analysis      | Source code analysis with multiple formats     |
| incident-response    | IR playbooks, runbooks, and workflows          |
| compliance-audit     | Compliance framework checklists                |
| threat-intelligence  | Threat feed integration and IOC analysis       |

## Configuration Options

Set environment variables or use the `.env` file in the project root:

| Variable               | Default            | Description                            |
|------------------------|--------------------|----------------------------------------|
| `SKILLS_DIR`           | `skills/`          | Directory containing skill definitions |
| `OUTPUT_DIR`           | `artifacts/`       | Output directory for generated reports |
| `LOG_LEVEL`            | `info`             | Logging verbosity level                |

## Verification

To verify that skills are properly loaded:

```bash
opencode agent list
```

You should see `cybersecurity-superpowers` in the list of available agents.

## Uninstalling

Remove the agent configuration from your OpenCode config file, or delete this repository.

---

For full documentation, see the [main README](../README.md).