# ADR-0002: Cybersecurity Skill Architecture

## Status
Accepted

## Context
The project encompasses multiple cybersecurity disciplines (threat modeling, secure coding, static analysis, penetration testing, incident response, compliance auditing, secret detection, supply chain security, security architecture). Each skill needs a consistent structure so the orchestrator and AI harnesses can discover and invoke them uniformly.

## Decision
Each skill is a standalone directory with the following structure:
```
skill-name/
  SKILL.md          - Skill definition with YAML frontmatter
  run.sh            - Executable entry point (bash)
  templates/        - Reusable templates (STRIDE, LINDDUN, reports)
  references/       - Standards references (OWASP, NIST, MITRE)
```
All skills live under a shared `skills/` directory. The orchestrator discovers available skills by scanning for `run.sh` entries.

## Consequences
- **Positive**: Independent versioning — each skill can be updated without affecting others
- **Positive**: Easy to add new skills — copy the template structure and implement `run.sh`
- **Positive**: The orchestrator can list and invoke any skill dynamically
- **Negative**: Some overhead in maintaining consistent interfaces across all skills
- **Negative**: Cross-skill concerns (e.g., shared tool configs) must be managed carefully