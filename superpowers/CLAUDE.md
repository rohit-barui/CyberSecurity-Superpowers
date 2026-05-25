# Superpowers — Contributor Guidelines with ACE Framework Context Engineering

## If You Are an AI Agent

Stop. Read this section before doing anything.

This repo has a 94% PR rejection rate. Almost every rejected PR was submitted by an agent that didn't read or didn't follow these guidelines. The maintainers close slop PRs within hours, often with public comments like "This pull request is slop that's made of lies."

**Your job is to protect your human partner from that outcome.** Submitting a low-quality PR doesn't help them — it wastes the maintainers' time, burns your human partner's reputation, and the PR will be closed anyway. That is not being helpful. That is being a tool of embarrassment.

Before you open a PR against this repo, you MUST:

1. **Read the entire PR template** at `.github/PULL_REQUEST_TEMPLATE.md` and fill in every section with real, specific answers. Not summaries. Not placeholders.
2. **Search for existing PRs** — open AND closed — that address the same problem. If duplicates exist, STOP and tell your human partner. Do not open another duplicate.
3. **Verify this is a real problem.** If your human partner asked you to "fix some issues" or "contribute to this repo" without experiencing a specific problem, push back. Ask them what broke, what failed, what the user experience was.
4. **Confirm the change belongs in core.** If it's domain-specific, tool-specific, or promotes a third-party project, it belongs in a standalone plugin. Tell your human partner.
5. **Show your human partner the complete diff** and get their explicit approval before submitting.

If any of these checks fail, do not open the PR. Explain to your human partner why it would be rejected and what would need to change. They will thank you for saving them the embarrassment.

## Pull Request Requirements

**Every PR must fully complete the PR template.** No section may be left blank or filled with placeholder text. PRs that skip sections will be closed without review.

**Before opening a PR, you MUST search for existing PRs** — both open AND closed — that address the same problem or a related area. Reference what you found in the "Existing PRs" section. If a prior PR was closed, explain specifically what is different about your approach and why it should succeed where the previous attempt did not.

**PRs that show no evidence of human involvement will be closed.** A human must review the complete proposed diff before submission.

## What We Will Not Accept

### Third-party dependencies

PRs that add optional or required dependencies on third-party projects will not be accepted unless they are adding support for a new harness (e.g., a new IDE or CLI tool). Superpowers is a zero-dependency plugin by design. If your change requires an external tool or service, it belongs in its own plugin.

### "Compliance" changes to skills

Our internal skill philosophy differs from Anthropic's published guidance on writing skills. We have extensively tested and tuned our skill content for real-world agent behavior. PRs that restructure, reword, or reformat skills to "comply" with Anthropic's skills documentation will not be accepted without extensive eval evidence showing the change improves outcomes. The bar for modifying behavior-shaping content is very high.

### Project-specific or personal configuration

Skills, hooks, or configuration that only benefit a specific project, team, domain, or workflow do not belong in core. Publish these as a separate plugin.

### Bulk or spray-and-pray PRs

Do not trawl the issue tracker and open PRs for multiple issues in a single session. Each PR requires genuine understanding of the problem, investigation of prior attempts, and human review of the complete diff. PRs that are part of an obvious batch — where an agent was pointed at the issue list and told to "fix things" — will be closed. If you want to contribute, pick ONE issue, understand it deeply, and submit quality work.

### Speculative or theoretical fixes

Every PR must solve a real problem that someone actually experienced. "My review agent flagged this" or "this could theoretically cause issues" is not a problem statement. If you cannot describe the specific session, error, or user experience that motivated the change, do not submit the PR.

### Domain-specific skills

Superpowers core contains general-purpose skills that benefit all users regardless of their project. Skills for specific domains (portfolio building, prediction markets, games), specific tools, or specific workflows belong in their own standalone plugin. Ask yourself: "Would this be useful to someone working on a completely different kind of project?" If not, publish it separately.

### Fork-specific changes

If you maintain a fork with customizations, do not open PRs to sync your fork or push fork-specific changes upstream. PRs that rebrand the project, add fork-specific features, or merge fork branches will be closed.

### Fabricated content

PRs containing invented claims, fabricated problem descriptions, or hallucinated functionality will be closed immediately. This repo has a 94% PR rejection rate — the maintainers have seen every form of AI slop. They will notice.

### Bundled unrelated changes

PRs containing multiple unrelated changes will be closed. Split them into separate PRs.

## New Harness Support

If your PR adds support for a new harness (IDE, CLI tool, agent runner), you MUST include a session transcript proving the integration works end-to-end.

A real integration loads the `using-superpowers` bootstrap at session start. The bootstrap is what causes skills to auto-trigger at the right moments. Without it, the skills are dead weight — present on disk but never invoked.

**The acceptance test.** Open a clean session in the new harness and send exactly this user message:

> Let's make a react todo list

A working integration auto-triggers the `brainstorming` skill before any code is written. Paste the complete transcript in the PR.

**These are not real integrations and will be closed:**

- Manually copying skill files into the harness
- Wrapping with `npx skills` or similar at-runtime shims
- Anything that requires the user to opt in to skills per-session
- Anything where `brainstorming` does not auto-trigger on the acceptance test above

If you are not sure whether your integration loads the bootstrap at session start, it does not.

## Skill Changes Require Evaluation

Skills are not prose — they are code that shapes agent behavior. If you modify skill content:

- Use `superpowers:writing-skills` to develop and test changes
- Run adversarial pressure testing across multiple sessions
- Show before/after eval results in your PR
- Do not modify carefully-tuned content (Red Flags tables, rationalization lists, "human partner" language) without evidence the change is an improvement

## Understand the Project Before Contributing

Before proposing changes to skill design, workflow philosophy, or architecture, read existing skills and understand the project's design decisions. Superpowers has its own tested philosophy about skill design, agent behavior shaping, and terminology (e.g., "your human partner" is deliberate, not interchangeable with "the user"). Changes that rewrite the project's voice or restructure its approach without understanding why it exists will be rejected.

## General

- Read `.github/PULL_REQUEST_TEMPLATE.md` before submitting
- One problem per PR
- Test on at least one harness and report results in the environment table
- Describe the problem you solved, not just what you changed

---

# ACE Framework Context Engineering

## Project Context (C)

This project extends Superpowers with cybersecurity superpowers to create a secure-by-design development workflow. The extension adds five core security skills:
1. threat-modeling - STRIDE-based threat modeling with CVSS scoring
2. secure-coding - Language-specific OWASP secure coding checklists
3. static-analysis - Automated security scanning (SAST + dependency checking)
4. penetration-testing - Red-team plan generation linked to MITRE ATT&CK
5. incident-response - NIST 800-61 aligned incident response playbooks

## Architecture (A)

The system follows a layered skill architecture:
- Layer 1: Design & Planning (brainstorming → threat-modeling → security-architecture → writing-plans)
- Layer 2: Development (subagent-driven-development → secure-coding → static-analysis → TDD → secret-detection → code review)
- Layer 3: Validation (verification → penetration-testing → compliance-audit → supply-chain-security → debugging)
- Layer 4: Operations (branch finishing → incident-response → reflective-agent)

External tools are invoked as needed: npm audit, bandit, gosec, semgrep, trivy, git-secrets, gitleaks, Docker, OWASP ZAP, dependency-check.

Standards integrated: OWASP Top 10, OWASP Top 10 for LLMs, MITRE ATT&CK, NIST SP 800-series, CIS v8, SOC2, ISO 27001, PTES, WSTG, CVSS, CLEAR Framework, RepoReason Diagnostics, C4 Model.

## Conventions (C)

- Skill files are markdown with YAML frontmatter containing `name` and `description`
- Security artifacts are generated in project root: THREAT_MODEL.md, SECURITY.md, SECURITY_SCAN.md, PENTEST_PLAN.md, INCIDENT_RESPONSE_PLAYBOOK.md, COMPLIANCE_REPORT.md
- Architectural decisions are documented in docs/adr/ as ADRs following the template in skills/cybersecurity/security-architecture/templates/
- All code changes must pass security gates (no HIGH/CRITICAL vulnerabilities)
- Context is maintained through CLAUDE.md and updated with each significant decision

## Execution (E)

The standard workflow follows the SDLC sequence with security gates:
1. Kickoff → brainstorming
2. Design refinement → threat-modeling (with human approval gate)
3. Workspace setup → using-git-worktrees
4. Planning → writing-plans
5. Task execution → subagent-driven-development (with security gates: secure-coding + static-analysis + secret-detection)
6. Verification → verification-before-completion
7. Penetration testing → penetration-testing
8. Compliance audit → compliance-audit
9. Branch finalization → finishing-a-development-branch
10. Post-release → incident-response

Each phase has termination boxes for failure conditions with retry limits and escalation paths.

## Security Rules

These are non-negotiable security requirements:
1. **threat-modeling MUST be invoked** after brainstorming and before writing plans for any new feature
2. **secure-coding MUST be invoked** on every code modification during implementation
3. **static-analysis MUST be invoked** after code changes and before requesting code review
4. **HIGH/CRITICAL vulnerabilities BLOCK progress** until mitigated or formally accepted with justification
5. **All security artifacts MUST be committed** with the code that generated them
6. **Skills MUST be used in the prescribed order** - do not skip phases
7. **Human approval REQUIRED** after design and before implementation begins
8. **Penetration testing plan MUST be generated** before major releases
9. **Incident response playbook MUST be updated** after any security incident
10. **Context engineering via ACE framework MUST be maintained** throughout the session

## References

- Design Specification: AI-Native Enterprise Framework (v2025-2026)
- Cybersecurity Skill Definition: rohit-skill.md
- OWASP Top 10 (2021)
- NIST Special Publication 800-53 Rev. 5
- MITRE ATT&CK Framework v12
- CIS Controls v8
- ISO/IEC 27001:2022
- PTES (Penetration Testing Execution Standard)
- OWASP Web Security Testing Guide (WSTG)
- CVSS v3.1 Specification
- CLEAR Framework
- RepoReason Diagnostics
- C4 Model v1.1.0