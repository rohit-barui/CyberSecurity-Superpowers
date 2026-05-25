# Ultimate Cybersecurity Superpowers — Master Plan (Table Format)

## 1. Foundation: What We Are Building On

| Source | Component | Items |
|---|---|---|
| **Superpowers Base** (rohit-barui/superpowers) | Core Skills | brainstorming, writing-plans, executing-plans, subagent-driven-development, dispatching-parallel-agents, test-driven-development, systematic-debugging, verification-before-completion, requesting-code-review, receiving-code-review, using-git-worktrees, finishing-a-development-branch, using-superpowers, writing-skills |
| **Cybersecurity Extension** (rohit-skill.md) | New Skills to Create | threat-modeling, secure-coding, static-analysis, penetration-testing, incident-response |
| **AI-Native Enterprise Framework** (v2025-2026) | Architectural Patterns | ReAct paradigm, 5 Orchestration Patterns (Orchestrator/Collaborative/Hierarchical/Reflective/Hybrid), ACE Framework, C4 Model, CLEAR Framework, RepoReason Diagnostics, OWASP Top 10 for LLMs, Self-healing infrastructure, Data Lakehouse-Mesh + MCP governance |

---

## 2. Final System Architecture — Directory Structure

| Directory / File | Purpose | Status |
|---|---|---|
| `AGENTS.md` | Agent behavior rules (merged + security-hardened) | Modified |
| `CLAUDE.md` | Context engineering (ACE Framework) | Modified |
| `README.md` | Project overview | New |
| `SECURITY.md` | Top-level security posture | New |
| `skills/core/` | Original Superpowers skills (preserved unchanged) | Existing |
| `skills/cybersecurity/threat-modeling/` | STRIDE + CVSS + MITRE ATT&CK mapping | New |
| `skills/cybersecurity/threat-modeling/templates/` | stride-model.md, attack-tree.md, threat-catalog.md | New |
| `skills/cybersecurity/threat-modeling/references/` | owasp-top10-llm.md, nist-800-30.md, mitre-attack-matrix.md | New |
| `skills/cybersecurity/secure-coding/` | Language-specific OWASP checklists | New |
| `skills/cybersecurity/secure-coding/checklists/` | javascript.md, python.md, typescript.md, go.md, rust.md | New |
| `skills/cybersecurity/secure-coding/templates/` | security-checklist.md | New |
| `skills/cybersecurity/static-analysis/` | Automated audit tool orchestration | New |
| `skills/cybersecurity/static-analysis/tools/` | npm-audit.sh, bandit-config.yaml, gosec-config.yaml, semgrep-rules.yaml | New |
| `skills/cybersecurity/static-analysis/templates/` | security-scan-report.md | New |
| `skills/cybersecurity/penetration-testing/` | Red-team plan generation | New |
| `skills/cybersecurity/penetration-testing/templates/` | pentest-plan.md, owasp-wstg-mapping.md, mitre-attack-plan.md | New |
| `skills/cybersecurity/penetration-testing/references/` | owasp-wstg.md, ptes-checklist.md | New |
| `skills/cybersecurity/incident-response/` | NIST 800-61 aligned playbooks | New |
| `skills/cybersecurity/incident-response/templates/` | incident-playbook.md, communication-template.md, lessons-learned.md | New |
| `skills/cybersecurity/incident-response/references/` | nist-800-61.md | New |
| `skills/cybersecurity/compliance-audit/` | CIS Controls v8 + SOC2 + ISO27001 | New |
| `skills/cybersecurity/compliance-audit/frameworks/` | cis-controls-v8.md, soc2-controls.md, iso27001-controls.md | New |
| `skills/cybersecurity/compliance-audit/templates/` | compliance-report.md | New |
| `skills/cybersecurity/secret-detection/` | Pre-commit + runtime secret scanning | New |
| `skills/cybersecurity/secret-detection/patterns/` | secret-patterns.yaml | New |
| `skills/cybersecurity/supply-chain-security/` | SBOM generation + dependency auditing | New |
| `skills/cybersecurity/supply-chain-security/templates/` | sbom-report.md | New |
| `skills/cybersecurity/security-architecture/` | C4 diagrams + Architecture Decision Records | New |
| `skills/cybersecurity/security-architecture/templates/` | c4-context.md, c4-container.md, c4-component.md, adr-template.md | New |
| `skills/cybersecurity/security-architecture/references/` | c4-model-guide.md | New |
| `skills/orchestration/orchestrator/` | ReAct loop + agent routing | New |
| `skills/orchestration/reflective-agent/` | Output validation + course correction | New |
| `skills/orchestration/clear-evaluator/` | CLEAR + RepoReason metrics | New |
| `hooks/pre-commit/` | secret-scan.sh, dependency-audit.sh, static-analysis.sh | New |
| `hooks/pre-push/` | threat-model-validate.sh, compliance-check.sh | New |
| `scripts/` | setup.sh, run-clear-eval.sh, generate-sbom.sh, run-security-suite.sh | New |
| `docs/architecture/` | c4-context.md, c4-container.md, c4-component.md, sequence-diagrams.md | New |
| `docs/adr/` | 0001-adopt-superpowers-base.md, 0002-integrate-ace-framework.md, 0003-security-by-design.md, 0004-multi-agent-orchestration.md | New |
| `docs/agents/` | skills-config.yaml | New |
| `tests/skills/` | Skill unit tests | New |
| `tests/integration/` | End-to-end workflow tests | New |
| `tests/security/` | Security validation tests | New |
| `.claude-plugin/plugin.json` | Claude plugin config | New |
| `.opencode/config.json` | OpenCode config | New |
| `package.json` | Package metadata | New |

---

## 3. Sequence Diagram — SDLC Flow with Termination Boxes

| Step | Stage | Skill Invoked | Key Actions | Decision Point | Next Step / Termination |
|---|---|---|---|---|---|
| 1 | Kickoff | — | Human says "Let's build X" | — | → Step 2 |
| 2 | Design Refinement | brainstorming | Clarify intent, explore alternatives, present design sections | Human approves? | Approve → Step 3 / Reject → Loop (max 5) → **T1** |
| 3 | Threat Analysis | threat-modeling | STRIDE analysis, CVSS scoring, MITRE ATT&CK mapping, OWASP LLM Top 10 check | Critical threats? | Mitigated → Step 4 / Unacceptable → Redesign (max 3) → **T2** |
| 4 | Workspace Setup | using-git-worktrees | Create isolated branch, run project setup, verify clean test base | Setup succeeds? | Success → Step 5 / Fails → Debug (max 2) → **T3** |
| 5 | Planning | writing-plans | Break work into tasks (2-5 min each), attach security requirements per task | Human says "go"? | Go → Step 6 |
| 6 | Task Execution | subagent-driven-development | Stage 1: Spec compliance review → Stage 2: Code quality review → Security Gate (secure-coding + static-analysis + secret-detection) | All pass? | Pass → Commit / Fail → Retry (max 3) → **T4/T5/T6** |
| 7 | Verification | verification-before-completion | Full test suite, full security suite, CLEAR evaluation, RepoReason diagnostics | All checks pass? | Pass → Step 8 / Fail → Debug (max 3) → **T7** |
| 8 | Penetration Testing | penetration-testing | Generate red-team plan, map to MITRE ATT&CK + OWASP WSTG, produce pentest-plan.md | — | → Step 9 |
| 9 | Compliance Audit | compliance-audit | CIS Controls v8, SOC2/ISO27001 mapping, generate compliance-report.md | Critical gaps? | Remediate (max 2) → Re-audit / Blocked → **T8** |
| 10 | Branch Finalization | finishing-a-development-branch | Verify all tests + security gates, present merge options (merge/PR/keep/discard) | Human choice? | Merge/PR → Step 11 / Discard → **T9** |
| 11 | Post-Merge Operations | incident-response | Generate NIST 800-61 playbook, communication templates, lessons-learned.md, update threat-catalog, archive ADRs | — | → **T10** |

---

## 4. Termination Box Summary

| ID | Name | Trigger | Max Retries | Outcome | Artifacts Produced |
|---|---|---|---|---|---|
| T1 | Design Rejected | Human rejects after max 5 brainstorm iterations | 5 | Session ends, no artifacts | None |
| T2 | Unacceptable Threats | Critical threats found, max 3 redesigns exhausted | 3 | Human must re-scope | Partial threat-catalog.md |
| T3 | Environment Broken | Worktree setup fails, max 2 debug cycles exhausted | 2 | Human intervention required | Debug logs |
| T4 | Task Exhausted | Subagent cannot complete task after 3 attempts | 3 | Human escalation | Partial task output |
| T5 | Quality Bar Failed | Code quality review fails after max retries | Configurable | Human review required | Code with review notes |
| T6 | Unfixable Vulnerability | HIGH/CRITICAL vuln found, cannot be remediated | 3 | Architecture redesign needed | SECURITY_SCAN.md |
| T7 | Critical Failure | Tests or security checks fail at verification, max 3 fix cycles | 3 | Rollback branch | Failed test reports |
| T8 | Compliance Blocked | Critical compliance gaps, max 2 remediation cycles | 2 | Release blocked | compliance-report.md |
| T9 | Discarded | Human chooses discard at finish | — | Branch deleted, worktree cleaned | None |
| T10 | Release Complete | All gates passed, merged | — | Full artifact suite | Code + security reports + compliance report + pentest plan + incident playbook + ADRs |

---

## 5. Final System — 4 Skill Layers

| Layer | Skills (Existing → New) | Description |
|---|---|---|
| **LAYER 1: Design & Planning** | brainstorming → **threat-modeling** → **security-architecture** → writing-plans | Socratic design refinement, STRIDE/CVSS/MITRE threat analysis, C4 model + ADR generation, task breakdowns with security requirements |
| **LAYER 2: Development (per task)** | subagent-driven-development → **secure-coding** → **static-analysis** → test-driven-development → **secret-detection** → requesting-code-review | Two-stage subagent execution, OWASP language checklists, SAST tool orchestration, RED-GREEN-REFACTOR, credential leak scanning, security checklist in code review |
| **LAYER 3: Validation** | verification-before-completion → **penetration-testing** → **compliance-audit** → **supply-chain-security** → systematic-debugging | Full test + security suite run, red-team plan generation, CIS/SOC2/ISO27001 assessment, SBOM + dependency CVE audit, 4-phase root cause analysis |
| **LAYER 4: Operations** | finishing-a-development-branch → **incident-response** → **reflective-agent** | Merge/PR workflow, NIST 800-61 playbooks + communication templates + lessons-learned, self-review and course correction |

---

## 6. Orchestration & Context Engineering

| Component | Skill / File | Function |
|---|---|---|
| **Orchestrator** | skills/orchestration/orchestrator/SKILL.md | Central ReAct loop, routes tasks to specialized sub-agents |
| **Reflective Agent** | skills/orchestration/reflective-agent/SKILL.md | Monitors own outputs, course-corrects before final commit |
| **CLEAR Evaluator** | skills/orchestration/clear-evaluator/SKILL.md | Measures Cost, Latency, Efficacy, Assurance, Reliability + RepoReason diagnostics |
| **ACE Framework** | CLAUDE.md + AGENTS.md + domain knowledge files | Project context, coding conventions, feedback commands, domain knowledge — 86% drift reduction |
| **Security Governance** | OWASP Top 10 + NIST 800-series + MITRE ATT&CK + CIS v8 + SOC2 + ISO27001 + PTES + WSTG | Policy enforcement across all layers |
| **Sandboxing** | Docker containers | Isolated tool execution, limited filesystem access |

---

## 7. External Tool Dependencies

| Tool | Purpose | Required/Optional | Language Scope |
|---|---|---|---|
| npm audit | Node.js dependency vulnerability scanning | Required | JavaScript/TypeScript |
| bandit | Python static security analysis | Required | Python |
| gosec | Go static security analysis | Required | Go |
| semgrep | Multi-language SAST | Required | All |
| trivy | Container + SBOM scanning | Required | All |
| git-secrets / gitleaks | Credential leak detection | Required | All |
| Docker | Sandboxed tool execution | Required | All |
| OWASP ZAP | DAST (dynamic application security testing) | Optional | Web apps |
| OWASP dependency-check | Dependency CVE scanning | Required | All |

---

## 8. Framework & Standard Dependencies

| Framework / Standard | Version | Integration Point |
|---|---|---|
| OWASP Top 10 (Web) | Current | secure-coding checklists, threat-modeling |
| OWASP Top 10 for LLMs | Current | threat-modeling, security-architecture |
| OWASP WSTG | Current | penetration-testing plans |
| MITRE ATT&CK | Current | threat-modeling, penetration-testing |
| NIST SP 800-30 | Current | threat-modeling risk assessment |
| NIST SP 800-53 | Current | compliance-audit controls |
| NIST SP 800-61 | Current | incident-response playbooks |
| NIST SP 800-115 | Current | penetration-testing methodology |
| CIS Controls v8 | Current | compliance-audit |
| SOC2 | Current | compliance-audit |
| ISO27001 | Current | compliance-audit |
| PTES | Current | penetration-testing |
| CVSS | v3.1/v4.0 | threat severity scoring |
| CLEAR Framework | Current | performance evaluation |
| RepoReason Diagnostics | Current | codebase reasoning metrics |
| ACE Framework | Current | context engineering |
| C4 Model | Current | architecture documentation |

---

## 9. Internal Skill Dependency Graph

| From Skill | Triggers | To Skill(s) | Condition |
|---|---|---|---|
| using-superpowers | Session start | brainstorming | Always |
| brainstorming | Design approved | threat-modeling | Always |
| threat-modeling | Threats analyzed | security-architecture | Critical threats found |
| threat-modeling | Threats accepted | using-git-worktrees | Always |
| using-git-worktrees | Workspace ready | writing-plans | Always |
| writing-plans | Plan approved | subagent-driven-development | Human says "go" |
| subagent-driven-development | Per task | secure-coding, static-analysis, secret-detection | Always (parallel) |
| secure-coding + static-analysis + secret-detection | Security gate passed | test-driven-development | Always |
| test-driven-development | Tests pass | requesting-code-review | Always |
| requesting-code-review | Review approved | verification-before-completion | After all tasks |
| verification-before-completion | All checks pass | penetration-testing | Always |
| penetration-testing | Pentest plan generated | compliance-audit | Always |
| compliance-audit | Compliance assessed | systematic-debugging | If failures found |
| compliance-audit | Compliance passed | finishing-a-development-branch | Always |
| finishing-a-development-branch | Merged | incident-response | Always |
| incident-response | Playbook generated | reflective-agent | Always |

---

## 10. Implementation Phases (Modernization Roadmap)

| Phase | Name | Timeline | Deliverables | Status |
|---|---|---|---|---|
| **Phase 1** | Discovery | Weeks 1-2 | Clone superpowers base, audit existing skills for security integration points, define threat modeling templates (STRIDE, attack trees), map OWASP/NIST/MITRE references to skill content | Not Started |
| **Phase 2** | Foundation | Weeks 3-6 | Create `skills/cybersecurity/` directory, implement threat-modeling + secure-coding + static-analysis + secret-detection skills, create pre-commit/pre-push hooks, update AGENTS.md + CLAUDE.md | Not Started |
| **Phase 3** | Core Security Skills | Weeks 7-10 | Implement penetration-testing + incident-response + compliance-audit + supply-chain-security + security-architecture skills, create orchestration layer skills | Not Started |
| **Phase 4** | Orchestration & Integration | Weeks 11-14 | Implement orchestrator (ReAct loop) + reflective-agent + CLEAR evaluator, wire security gates into subagent-driven-development, integrate with Superpowers workflow, create sequence diagram documentation | Not Started |
| **Phase 5** | Testing & Validation | Weeks 15-18 | Write skill unit tests, run integration tests across harnesses (Claude Code, OpenCode, Cursor, etc.), adversarial pressure testing, CLEAR evaluation, RepoReason baseline, documentation (README, docs/, ADRs) | Not Started |
| **Phase 6** | Optimization | Ongoing | Automated observability, cost governance, continuous improvement from incident-response feedback loops, update threat catalogs with new knowledge | Not Started |

---

## 11. Architecture Decision Records (ADRs)

| ADR ID | Title | Decision | Rationale |
|---|---|---|---|
| ADR-001 | Preserve Superpowers Core | Keep all original Superpowers skills unchanged; create cybersecurity skills as additive layer | Superpowers has 94% PR rejection rate for core modifications; domain-specific skills belong in plugins |
| ADR-002 | Zero Runtime Dependencies | All security tools invoked as external commands (bash scripts), not npm/python packages | Superpowers is zero-dependency by design; skills are pure markdown |
| ADR-003 | Security Gates Block Progress | HIGH/CRITICAL vulnerabilities block commit; Medium/Low generate warnings but don't block | Aligns with OWASP/NIST risk management; prevents shipping exploitable code |
| ADR-004 | Multi-Harness Support | Skills must work across Claude Code, OpenCode, Cursor, Gemini CLI, Codex CLI, GitHub Copilot CLI | Superpowers supports all major coding agents; cybersecurity extension must too |
| ADR-005 | ACE Framework for Context | Use CLAUDE.md + AGENTS.md + domain knowledge files for context engineering | Proven 86% reduction in architectural drift; machine-readable conventions enable agent self-verification |
