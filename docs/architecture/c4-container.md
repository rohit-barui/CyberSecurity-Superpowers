# C4 Container Diagram: CyberSecurity Superpowers

```mermaid
graph TD
    Dev([Developer]) -- "Prompts" --> AGENTS[AGENTS.md & configs]
    AGENTS -- "Discovers" --> Skills[Skill Definitions]
    Skills --> Threat["Threat Modeling<br/>(SKILL.md + templates)"]
    Skills --> Secure["Secure Coding<br/>(SKILL.md + checklists)"]
    Skills --> Static["Static Analysis<br/>(SKILL.md + tool configs)"]
    Skills --> PenTest["Penetration Testing<br/>(SKILL.md + plans)"]
    Skills --> IR["Incident Response<br/>(SKILL.md + playbooks)"]
    Skills --> Compliance["Compliance Audit<br/>(SKILL.md + frameworks)"]
    Skills --> Secrets["Secret Detection<br/>(SKILL.md + patterns)"]
    Skills --> Supply["Supply Chain<br/>(SKILL.md + SBOM)"]
    Skills --> Arch["Security Architecture<br/>(SKILL.md + C4 templates)"]
    Skills --> Orchestrator[Orchestrator]
    Orchestrator --> Reflective[Reflective Agent]
    Orchestrator --> CLEAR[CLEAR Evaluator]
```

## Container Security

| Container | Security Controls |
|-----------|------------------|
| AGENTS.md | Defines agent behavior constraints |
| Skill Definitions | YAML frontmatter with metadata validation |
| Orchestrator | Task routing with security gate enforcement |
| Reflective Agent | Self-review validation pipeline |
| CLEAR Evaluator | Metrics-based quality assurance |