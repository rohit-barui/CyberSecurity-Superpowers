---
name: security-architecture
description: "Generates C4 architecture diagrams and ADRs with security context."
---

# Security Architecture Skill

Generates C4 model diagrams and Architecture Decision Records (ADRs) with embedded security considerations.

## Process

1. Review system context and threat model
2. Create C4 context diagram showing system boundaries
3. Create C4 container diagram with security controls per container
4. Create C4 component diagram for critical components
5. Document ADRs for key security decisions
6. Archive in `docs/architecture/` and `docs/adr/`

## Output

- `docs/architecture/c4-context.md`
- `docs/architecture/c4-container.md`
- `docs/architecture/c4-component.md`
- `docs/adr/NNNN-title.md`