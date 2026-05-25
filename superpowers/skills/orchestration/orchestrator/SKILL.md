---
name: orchestrator
description: "Central ReAct loop that routes tasks to specialized sub-agents based on task type and context."
---

# Orchestrator Skill

Central ReAct loop that routes development tasks to the correct specialized skill.

## Process

1. Receive task from parent agent
2. Analyze task type: design, implementation, validation, operations
3. Route to appropriate skill (threat-modeling, subagent-driven-development, etc.)
4. Monitor execution and handle errors
5. Return results with security gate status

## Routing Rules

| Task Type | Primary Skill | Fallback | Security Gate |
|-----------|--------------|----------|---------------|
| Design | brainstorming, threat-modeling | security-architecture | CVSS check |
| Implementation | subagent-driven-development | secure-coding | SAST scan |
| Validation | verification-before-completion | penetration-testing | compliance check |
| Operations | finishing-a-development-branch | incident-response | artifact verification |