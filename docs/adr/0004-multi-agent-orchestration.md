# ADR-0004: Multi-Agent Orchestration Pattern

## Status
Proposed

## Context
The project includes multiple independent security skills. A developer may want to run a single skill (e.g., threat-model) or all skills sequentially (full mode). Additionally, CI/CD pipelines and Git hooks need automated, non-interactive execution modes. A lightweight orchestration mechanism is required that works without external dependencies.

## Decision
Use a bash-based orchestrator script (`orchestrator.sh`) that accepts a mode argument and routes execution to the appropriate skills:

| Mode | Behavior |
|------|----------|
| `implement` | Guides the developer through implementing a new skill |
| `threat-model` | Runs only the threat-modeling skill |
| `secure-coding` | Runs only the secure-coding skill |
| `full` | Runs all skills in sequence, consolidating results |
| `ci` | Runs a subset of skills suitable for CI/CD gates |
| `hook` | Runs a lightweight subset for Git pre-commit hooks |

The orchestrator discovers skills by scanning for `skills/*/run.sh`. Each skill is expected to accept arguments via CLI flags and return structured output (JSON or SARIF) on stdout.

## Consequences
- **Positive**: Simple to understand and debug — bash is universally available
- **Positive**: Each skill's `run.sh` is the sole interface contract; skills are decoupled from the orchestrator
- **Positive**: No language runtime dependencies beyond bash
- **Negative**: Bash has limited data structures; complex routing logic becomes hard to maintain
- **Negative**: Error handling in bash is verbose and easy to get wrong
- **Negative**: Parallel execution of skills would require additional complexity (background processes, temp files)