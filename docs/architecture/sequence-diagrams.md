# Sequence Diagrams

## Diagram 1: Orchestrator `full` Mode Execution

The developer invokes the orchestrator in `full` mode, which runs all skills sequentially. Each skill executes its `run.sh` and returns results to the orchestrator.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Harness as AI Harness
    participant Orch as Orchestrator
    participant TM as Threat-Model Skill
    participant SC as Secure-Coding Skill
    participant SA as Static-Analysis Skill
    participant Tools as External Tools

    Dev->>Harness: Run full security review
    Harness->>Orch: ./orchestrator.sh full
    Orch->>TM: run.sh threat-model
    TM->>TM: Load STRIDE templates
    TM-->>Orch: threat-model report
    Orch->>SC: run.sh secure-coding
    SC->>SC: Load language checklists
    SC-->>Orch: secure-coding report
    Orch->>SA: run.sh static-analysis
    SA->>Tools: Invoke semgrep/bandit/gosec
    Tools-->>SA: SARIF results
    SA-->>Orch: static-analysis report
    Orch-->>Harness: Consolidated full report
    Harness-->>Dev: Display findings & recommendations
```

## Diagram 2: Pre-Commit Hook Execution Flow

A developer commits code, triggering the Git pre-commit hook. The hook runs secret detection and secure-coding checks on staged files.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as Git
    participant Hook as Pre-Commit Hook
    participant Orch as Orchestrator
    participant Secret as Secret Detection
    participant SC as Secure-Coding Skill

    Dev->>Git: git commit
    Git->>Hook: Trigger pre-commit hook
    Hook->>Hook: Identify staged files
    Hook->>Orch: ./orchestrator.sh hook
    Orch->>Secret: run.sh gitleaks --staged
    Secret->>Secret: Scan staged diff
    Secret-->>Orch: secrets results
    Orch->>SC: run.sh secure-coding --staged
    SC->>SC: Check staged code
    SC-->>Orch: coding results
    Orch-->>Hook: combined hook results
    alt No issues found
        Hook-->>Git: Exit 0 (allow commit)
        Git-->>Dev: Commit successful
    else Issues found
        Hook-->>Git: Exit 1 (block commit)
        Git-->>Dev: Commit blocked, review findings
    end
```

## Diagram 3: CI Pipeline Execution Flow

A pull request is opened on GitHub, triggering a GitHub Actions workflow. The CI pipeline runs the orchestrator in `ci` mode for automated security gates.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant Orch as Orchestrator
    participant SA as Static-Analysis Skill
    participant SBOM as Supply-Chain Skill
    participant Tools as External Tools

    Dev->>GH: Push branch / Open PR
    GH->>GHA: Trigger CI workflow
    GHA->>GHA: Checkout code & setup env
    GHA->>Orch: ./orchestrator.sh ci
    Orch->>SA: run.sh static-analysis
    SA->>Tools: semgrep --config=auto
    Tools-->>SA: results.sarif
    SA-->>Orch: findings.json
    Orch->>SBOM: run.sh supply-chain
    SBOM->>Tools: trivy fs .
    Tools-->>SBOM: sbom.json + vulns
    SBOM-->>Orch: sbom-report.json
    Orch-->>GHA: combined-ci-report.json
    GHA->>GHA: Evaluate security gate
    alt Gate passes
        GHA-->>GH: ✅ Checks passed
        GH-->>Dev: PR ready for review
    else Gate fails
        GHA-->>GH: ❌ Security gate failed
        GH-->>Dev: PR blocked, view CI report
    end
```