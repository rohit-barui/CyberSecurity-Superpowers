---
name: reflective-agent
description: "Self-review and course correction agent that validates outputs before final commit."
---

# Reflective Agent Skill

Monitors own outputs, performs self-review, and course-corrects before final commit.

## Process

1. Capture output from each skill invocation
2. Validate against security gates and quality criteria
3. If issues found: generate correction plan and re-execute
4. If clean: approve for next stage

## Validation Criteria

| Check | Criteria | Action on Fail |
|-------|----------|----------------|
| Security Gate | No HIGH/CRITICAL vulnerabilities | Block and escalate |
| Quality Gate | Tests pass, no lint errors | Retry with fix |
| Completeness | All artifacts generated | Add missing artifacts |
| Consistency | No contradictions across artifacts | Flag for human review |