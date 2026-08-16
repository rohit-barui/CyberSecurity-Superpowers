---
name: clear-evaluator
description: "Evaluates project readiness across Context, Logic, Execution, Accuracy, and Relevance metrics."
---

# CLEAR Evaluator Skill

## Purpose

The CLEAR Evaluator provides a self-evaluation mechanism for the Cybersecurity Superpowers project using the **CLEAR** metrics framework from the **ACE** (Agent Capability Evaluation) methodology. It assesses project readiness across five dimensions and generates structured reports.

## Why Use This Skill

Self-evaluation is essential for autonomous agent workflows to guarantee quality and release readiness before deployment.

- 📊 **Quantifiable Readiness**: Evaluates project readiness on a 50-point scale across Context, Logic, Execution, Accuracy, and Relevance.
- ⚡ **Automated Diagnostics**: Scans project structure, scripts, and documentation automatically.
- 🏆 **ACE Framework Alignment**: Based on industry-leading Agent Capability Evaluation methodologies.
- 📜 **Continuous Improvement**: Provides concrete scoring rationale and action items for quality gaps.

## Metrics

| Metric     | Description                                              | Max Score |
|------------|----------------------------------------------------------|-----------|
| Context    | Completeness of documentation and project context        | 10        |
| Logic      | Logical consistency of structure and interfaces          | 10        |
| Execution  | Readiness for execution — tests, setup, CI/CD            | 10        |
| Accuracy   | Adherence to best practices and quality standards        | 10        |
| Relevance  | Applicability and usefulness to the target domain        | 10        |

## Process Flow

```
Scan Project Structure
       ↓
Score Each CLEAR Metric (0–10)
       ↓
Aggregate Scores → Total (50 max)
       ↓
Generate Report (markdown or JSON)
       ↓
Output: artifacts/reports/clear-evaluation.md
```

## Usage

```bash
# Generate full report
bash scripts/run-clear-eval.sh

# Dry-run with JSON output
bash scripts/run-clear-eval.sh --dry-run

# Custom output directory
bash scripts/run-clear-eval.sh --output-dir custom/reports

# Verbose mode with scoring rationale
bash scripts/run-clear-eval.sh --verbose
```

## References

- ACE Framework: The CLEAR metrics are derived from the Agent Capability Evaluation (ACE) methodology for assessing AI agent skill readiness.
- Score interpretation: 90%+ = Release-ready, 70–89% = Good with room for improvement, 50–69% = Needs significant work, <50% = Early stage.

## Files

- `scripts/run-clear-eval.sh` — The evaluation script.
- `artifacts/reports/clear-evaluation.md` — Generated report output.