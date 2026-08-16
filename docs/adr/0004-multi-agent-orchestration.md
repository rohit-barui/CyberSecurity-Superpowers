# ADR-0004: Multi-Agent Orchestration Pattern

## Status
Accepted

## Context
The project includes multiple independent security skills. A developer may want to run a single skill (e.g., threat-model) or all skills sequentially (full mode). Additionally, CI/CD pipelines need automated, non-interactive execution modes. A lightweight orchestration mechanism is required that works without external dependencies.

## Decision
Use a bash-based orchestrator script (`scripts/run-orchestrator.sh`) that accepts a mode argument and routes execution to the appropriate skills:

| Mode | Behavior |
|------|----------|
| `implement` | Runs secure-coding + static-analysis for development tasks |
| `threat-model` | Runs only the threat-modeling skill |
| `full` | Runs all 5 core skills in sequence (threat-modeling, secure-coding, static-analysis, penetration-testing, incident-response) |

The orchestrator discovers skills by scanning for `skills/cybersecurity/*/run.sh`. Each skill is expected to accept arguments via CLI flags (`--project`, `--target-dir`, `--output-dir`, etc.) and produce markdown/JSON output files.

Additional scripts available:
- `scripts/run-security-suite.sh` — Batch runner for all 5 skills with summary table
- `scripts/setup.sh` — Environment verification and setup
- `scripts/generate-sbom.sh` — SBOM generation (supply-chain security)

## Consequences
- **Positive**: Simple to understand and debug — bash is universally available
- **Positive**: Each skill's `run.sh` is the sole interface contract; skills are decoupled from the orchestrator
- **Positive**: No language runtime dependencies beyond bash
- **Positive**: Git hooks are standalone bash scripts (not dependent on orchestrator)
- **Negative**: Bash has limited data structures; complex routing logic becomes hard to maintain
- **Negative**: Error handling in bash is verbose and easy to get wrong