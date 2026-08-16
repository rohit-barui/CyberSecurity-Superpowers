# ADR-0001: Adopt Superpowers Base Framework

## Status
Accepted

## Context
The project needed a foundation for building reusable AI-assisted cybersecurity engineering capabilities. Building a custom framework from scratch would incur significant development and maintenance costs. The open-source Superpowers agent skill framework provides a proven, extensible architecture for defining skills as standalone markdown + script bundles.

## Decision
Adopt the Superpowers agent skill framework as the base architecture. Skills are defined as self-contained directories with SKILL.md metadata, templates, and run scripts. The orchestrator pattern from Superpowers is used to coordinate multi-skill workflows.

## Consequences
- **Positive**: Compatible with Claude Code, OpenCode, Cursor, Gemini CLI, and Codex OSS — any harness that supports Superpowers-style agents
- **Positive**: Leverages existing community patterns and conventions
- **Positive**: Rapid onboarding for developers familiar with the Superpowers ecosystem
- **Negative**: Bound by Superpowers' architectural conventions; unconventional requirements may be harder to implement
- **Negative**: Upstream Superpowers changes may require adaptation