# ADR-0003: Harness-Agnostic Deployment

## Status
Accepted

## Context
The skills should work across multiple AI coding harnesses (Claude Code, OpenCode, Cursor, Gemini CLI, etc.).

## Decision
Skills will be written as standalone markdown files with YAML frontmatter. No harness-specific configuration formats. Each user installs via their harness's configuration mechanism.

## Consequences
- Skills are portable across all supported harnesses
- No dependency on any single ecosystem
- Users must manually configure their harness to discover these skills

## Security Implications
- Reducing attack surface by not hardcoding credentials per harness
- Users control which skills are active in which harness