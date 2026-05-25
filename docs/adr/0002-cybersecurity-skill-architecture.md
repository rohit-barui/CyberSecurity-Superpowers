# ADR-0002: Cybersecurity Skill Architecture

## Status
Accepted

## Context
We need a consistent structure for all cybersecurity skill modules that can be extended with new skills over time.

## Decision
Each skill follows a standard directory structure:
```
skill-name/
  SKILL.md          - Skill definition (YAML frontmatter + markdown)
  templates/        - Reusable templates
  references/       - Standards references (OWASP, NIST, etc.)
  checklists/       - Interactive checklists
  tools/            - Tool configurations
```

## Consequences
- Consistent discovery and invocation across all skills
- Easy to add new skills by copying template structure
- May have some redundancy across similar skills

## Security Implications
- Standardized structure ensures security gates are consistently applied
- References to authoritative sources (OWASP, NIST) ensure correct security guidance