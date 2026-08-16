# ADR-0003: Harness-Agnostic Deployment

## Status
Accepted

## Context
The cybersecurity skills should be usable across all major AI coding assistants: Claude Code, Cursor, Codex OSS, OpenCode, and Gemini CLI. Each assistant has its own plugin/configuration mechanism and discovery format.

## Decision
Provide plugin manifests for each supported assistant:
- **Claude Code**: `claude_plugin.json` + CLAUDE.md configuration
- **Cursor**: `cursor_plugin.json` + Cursor rules configuration
- **Codex OSS**: Codex agent configuration files
- **OpenCode**: AGENTS.md with skill references
- **Gemini CLI**: Gemini CLI agent definitions

The core skill content remains harness-agnostic (plain SKILL.md + run.sh). Only the installation/registration mechanism differs per harness.

## Consequences
- **Positive**: Broader reach — security engineers can use their preferred AI assistant
- **Positive**: Core skill logic is developed once and deployed everywhere
- **Positive**: Harness-specific bugs are isolated to thin plugin layers
- **Negative**: More maintenance — each harness plugin must be kept in sync
- **Negative**: Different harnesses support different feature sets; some capabilities may degrade on less capable assistants