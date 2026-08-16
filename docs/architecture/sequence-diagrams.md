# Sequence Diagrams

## Diagram 1: Orchestrator `full` Mode Execution

The developer invokes the orchestrator in `full` mode, which runs all skills sequentially. Each skill executes its `run.sh` and returns results.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Harness as AI Harness
    participant Orch as Orchestrator
    participant TM as Threat-Model Skill
    participant SC as Secure-Coding Skill
    participant SA as Static-Analysis Skill
    participant PT as Pentest Skill
    participant IR as Incident-Response Skill
    participant Tools as External Tools

    Dev->>Harness: Run full security review
    Harness->>Orch: bash scripts/run-orchestrator.sh full "my-app"
    Orch->>TM: run.sh --project "my-app"
    TM->>TM: Load STRIDE templates
    TM-->>Orch: stride-model.md
    Orch->>SC: run.sh --language auto
    SC->>SC: Detect language, load checklists
    SC-->>Orch: SECURITY.md
    Orch->>SA: run.sh --target-dir . --dry-run
    SA->>Tools: Simulate semgrep/bandit/gosec
    Tools-->>SA: Mock findings
    SA-->>Orch: SECURITY_SCAN.md
    Orch->>PT: run.sh --target-app "my-app"
    PT-->>Orch: pentest-plan.md
    Orch->>IR: run.sh --incident-type ransomware
    IR-->>Orch: incident-playbook.md
    Orch-->>Harness: All reports generated
    Harness-->>Dev: Display findings summary
```

## Diagram 2: Pre-Commit Hook Execution Flow

A developer commits code, triggering the Git pre-commit hook. The hook runs secret detection, dependency audit, and static analysis on staged files.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as Git
    participant Hook as Pre-Commit Hook
    participant Secret as hooks/pre-commit/secret-scan.sh
    participant Audit as hooks/pre-commit/dependency-audit.sh
    participant SA as hooks/pre-commit/static-analysis.sh

    Dev->>Git: git commit
    Git->>Hook: Trigger pre-commit hook
    Hook->>Hook: Identify staged files
    Hook->>Secret: Scan for secrets
    Secret->>Secret: Check staged diff against regex patterns
    Secret-->>Hook: Pass/Fail
    Hook->>Audit: Audit dependencies
    Audit->>Audit: npm audit / pip-audit / go mod verify
    Audit-->>Hook: Pass/Warn
    Hook->>SA: Run static analysis
    SA->>SA: eslint / bandit / gosec
    SA-->>Hook: Warnings only
    alt No secrets found
        Hook-->>Git: Exit 0 (allow commit)
        Git-->>Dev: Commit successful
    else Secrets detected
        Hook-->>Git: Exit 1 (block commit)
        Git-->>Dev: Commit blocked, review findings
    end
```

## Diagram 3: CI Pipeline Execution Flow

A pull request is opened on GitHub, triggering a GitHub Actions workflow. The CI pipeline runs lint, skill tests, and orchestrator demo jobs.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant Lint as Lint Job
    participant Tests as Skill Tests Job
    participant Orch as Orchestrator Demo Job
    participant Build as Build Summary Job

    Dev->>GH: Push branch / Open PR
    GH->>GHA: Trigger CI workflow
    GHA->>Lint: Run lint job
    Lint->>Lint: shellcheck + yamllint + frontmatter check
    Lint-->>GHA: Pass/Fail
    GHA->>Tests: Run skill tests job
    Tests->>Tests: bash tests/run-skill-tests.sh
    Tests-->>GHA: Pass/Fail
    GHA->>Orch: Run orchestrator demo job
    Orch->>Orch: bash scripts/run-orchestrator.sh threat-model "Demo CI App"
    Orch-->>GHA: Pass/Fail
    GHA->>Build: Run build summary
    Build->>Build: Consolidate results
    alt All jobs pass
        Build-->>GH: ✅ CI passed
        GH-->>Dev: PR ready for review
    else Any job fails
        Build-->>GH: ❌ CI failed
        GH-->>Dev: Check CI logs
    end
```