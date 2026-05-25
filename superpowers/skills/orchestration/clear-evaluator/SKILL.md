---
name: clear-evaluator
description: "Measures Cost, Latency, Efficacy, Assurance, and Reliability metrics for agent outputs."
---

# CLEAR Evaluator Skill

Measures agent performance using the CLEAR framework and RepoReason diagnostics.

## Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Cost | Total tokens and API calls per task | Minimize |
| Latency | Time from request to completion | Under threshold |
| Efficacy | Accuracy and completeness of output | Pass rate |
| Assurance | Security gate compliance | 100% |
| Reliability | Consistency across repeated runs | Low variance |

## Process

1. After each skill invocation, log CLEAR metrics
2. Compare against baseline targets
3. If metrics deviate: adjust strategy (reduce scope, increase context)
4. Report in `docs/performance/clear-report.md`

## RepoReason Diagnostics

Evaluate reasoning quality:
- Relevance of source context used
- Path diversity in context retrieval
- Drift from previous architectural decisions