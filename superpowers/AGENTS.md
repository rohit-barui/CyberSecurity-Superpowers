# Agent Behavior Rules

## Core Principles

1. **Security First**: All actions must prioritize security. Invoke threat-modeling, secure-coding, and static-analysis skills as appropriate.
2. **Context Engineering**: Use the ACE Framework (in CLAUDE.md) to maintain accurate project context.
3. **Human-in-the-Loop**: Seek explicit human approval before proceeding with implementation after design.
4. **Zero Tolerance for Vulnerabilities**: Block progress on HIGH/CRITICAL security findings until mitigated.
5. **Skill Discipline**: Use the correct skill for each phase; do not skip steps.

## Phase-Specific Rules

### Design Phase
- After brainstorming, invoke threat-modeling to produce STRIDE-based threat model.
- Update SECURITY.md with identified threats and mitigations.
- Get human approval on threat model before proceeding.

### Implementation Phase
- For each code change:
  - Invoke secure-coding to apply language-specific OWASP checklists.
  - Invoke static-analysis to run SAST and dependency scanning.
  - If any HIGH/CRITICAL findings, block commit and require remediation.
- Run tests and verification-before-completion.

### Validation Phase
- After verification, invoke penetration-testing to generate red-team plan.
- Invoke compliance-audit to check against CIS v8, SOC2, ISO27001.
- Address any critical gaps before release.

### Release Phase
- Before merging, run incident-response to generate NIST-aligned playbook.
- Update threat catalog with lessons learned.
- Ensure all security artifacts are committed.

## Skill Invocation Guidelines

- **threat-modeling**: Use during design, after brainstorming, before writing plans.
- **secure-coding**: Use on every code modification during implementation.
- **static-analysis**: Use after code changes, before requesting code review.
- **penetration-testing**: Use after verification, before release, or on demand.
- **incident-response**: Use when a vulnerability is confirmed or after penetration test.
- **Orchestration Skills**: Use orchestrator, reflective-agent, clear-evaluator as needed for complex workflows.

## Context Engineering (ACE Framework)

- Refer to CLAUDE.md for ACE context elements.
- Keep context updated with architectural decisions (ADRs).
- Use CLEAR metrics and RepoReason diagnostics for self-evaluation.

## Harness Support

These rules apply across all supported harnesses: Claude Code, OpenCode, Cursor, Gemini CLI, Codex CLI, GitHub Copilot CLI.

## Violations

Any violation of these rules will result in the agent being instructed to correct the behavior before proceeding. Repeated violations may require session termination.