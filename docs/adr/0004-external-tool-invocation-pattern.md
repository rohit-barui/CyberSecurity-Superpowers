# ADR-0004: External Tool Invocation Pattern

## Status
Accepted

## Context
We need a consistent way for skills to invoke security tools without being coupled to specific tool implementations.

## Decision
Skills will invoke tools via `exec` / subprocess calls with standardized flags. Configuration lives in `tools/` subdirectories per skill. Results are captured in structured formats (JSON, SARIF, SPDX).

## Consequences
- Skills work with whatever tools are installed on the system
- No package manager coupling
- Users must install tools separately

## Security Implications
- Tool configurations (semgrep rules, bandit configs) are version-controlled
- Results captured in standard formats for audit trails