# Good First Issues

This page lists curated issues tagged `good-first-issue` that are suitable for new contributors. Each issue includes implementation guidance and links to relevant files.

---

## Issue 1: Add Java Checklists to Secure-Coding Skill

| Field | Value |
|-------|-------|
| **Skill Area** | `secure-coding` |
| **Difficulty** | Easy |
| **Labels** | `good-first-issue`, `skill-secure-coding` |

### Description
The secure-coding skill currently includes security checklists for Python, JavaScript/TypeScript, and C/C++ but is missing Java. Add a new checklist file covering common Java security vulnerabilities including SQL injection (prepared statements), deserialization attacks, insecure reflection, XXE, and improper logging of sensitive data.

### Expected Outcome
A new file `skills/secure-coding/checklists/java.md` containing a structured security checklist for Java development. The file should follow the same format as existing checklists (e.g., `python.md`).

### Suggested Implementation Steps
1. Read the existing checklists in `skills/secure-coding/checklists/` to understand the format.
2. Research OWASP Java-specific vulnerabilities (SQL injection, deserialization, XXE, etc.).
3. Create `skills/secure-coding/checklists/java.md` following the same template.
4. Update `skills/secure-coding/SKILL.md` to reference the new checklist.

### Files to Modify
- `skills/secure-coding/checklists/java.md` (create)
- `skills/secure-coding/SKILL.md` (update references)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh --skill secure-coding` to verify existing tests still pass.
- Manually review the checklist for completeness against OWASP Java Top 10.

---

## Issue 2: Create SARIF Output Format Test for Static-Analysis

| Field | Value |
|-------|-------|
| **Skill Area** | `static-analysis` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-static-analysis` |

### Description
The static-analysis skill supports SARIF output via `--format sarif` but lacks automated tests validating that the output conforms to the SARIF specification. Create a test that runs the static-analysis tool with `--format sarif`, validates the JSON structure against the SARIF v2.1.0 schema, and checks key fields.

### Expected Outcome
A new test file (or test function) in `tests/` that validates SARIF output correctness. The test should catch malformed output, missing required fields, and structural errors.

### Suggested Implementation Steps
1. Study the SARIF v2.1.0 specification (OASIS standard).
2. Read the current test infrastructure in `tests/run-skill-tests.sh`.
3. Create `tests/static-analysis/test-sarif-output.sh`.
4. Use `jq` to validate JSON structure against expected SARIF fields.
5. Integrate the test into `tests/run-skill-tests.sh`.

### Files to Modify
- `tests/static-analysis/test-sarif-output.sh` (create)
- `tests/run-skill-tests.sh` (add test invocation)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh --skill static-analysis` to confirm the new test passes.
- Intentionally break the SARIF output to ensure the test fails correctly.

---

## Issue 3: Add "malware-infection" Incident Type to Incident-Response Skill

| Field | Value |
|-------|-------|
| **Skill Area** | `incident-response` |
| **Difficulty** | Easy |
| **Labels** | `good-first-issue`, `skill-incident-response` |

### Description
The incident-response skill supports predefined incident types (e.g., `phishing`, `data-breach`, `ransomware`) but not `malware-infection`. Add this incident type with a corresponding runbook, checklist, and playbook following the existing pattern.

### Expected Outcome
Users can invoke `bash skills/incident-response/run.sh --type malware-infection` and receive a full incident response workflow covering detection, containment, eradication, and recovery for malware infections.

### Suggested Implementation Steps
1. Examine an existing incident type (e.g., `data-breach`) to understand the file structure.
2. Create checklists and playbooks for `malware-infection` following the same pattern.
3. Register the new type in the skill's configuration or routing logic.
4. Update `skills/incident-response/SKILL.md` to list the new incident type.

### Files to Modify
- `skills/incident-response/checklists/malware-infection.md` (create)
- `skills/incident-response/playbooks/malware-infection.json` (create)
- `skills/incident-response/SKILL.md` (update)
- Any routing/config file that maps incident types to workflows

### Testing Guidance
- Run `bash skills/incident-response/run.sh --type malware-infection` and verify the output.
- Run `bash tests/run-skill-tests.sh --skill incident-response` to ensure no regressions.

---

## Issue 4: Implement `--severity-threshold` Flag for Static-Analysis run.sh

| Field | Value |
|-------|-------|
| **Skill Area** | `static-analysis` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-static-analysis` |

### Description
The `skills/static-analysis/run.sh` script currently reports all findings regardless of severity. Add a `--severity-threshold` flag that filters results to only show findings at or above a specified severity level (e.g., `--severity-threshold high` shows only high and critical findings). Supported levels: `low`, `medium`, `high`, `critical`.

### Expected Outcome
Users can run `bash skills/static-analysis/run.sh --severity-threshold high` and only see findings with severity "high" or "critical". The flag must be documented in `--help` output.

### Suggested Implementation Steps
1. Read `skills/static-analysis/run.sh` to understand argument parsing and output logic.
2. Add `--severity-threshold` with a default of `low` (show everything).
3. Implement filtering logic after analysis runs.
4. Update `--help` output to document the new flag.
5. Add tests for the new flag behavior.

### Files to Modify
- `skills/static-analysis/run.sh` (add flag, filtering, help text)
- `tests/static-analysis/test-severity-threshold.sh` (create or add to existing)

### Testing Guidance
- Run with `--severity-threshold critical` and confirm only critical findings appear.
- Run with `--severity-threshold low` and confirm all findings appear.
- Verify `--help` shows the new flag.

---

## Issue 5: Add Compliance-Audit Skill SKILL.md and Framework References

| Field | Value |
|-------|-------|
| **Skill Area** | `compliance-audit` |
| **Difficulty** | Easy |
| **Labels** | `good-first-issue`, `skill-compliance-audit` |

### Description
The compliance-audit skill exists but lacks a proper `SKILL.md` file and does not reference the compliance frameworks it supports (e.g., SOC 2, ISO 27001, PCI DSS, HIPAA, GDPR). Create a comprehensive `SKILL.md` documenting the skill's purpose, supported frameworks, audit process, and usage examples.

### Expected Outcome
A complete `skills/compliance-audit/SKILL.md` that explains the skill's capabilities, lists all supported compliance frameworks, provides usage examples, and links to framework-specific checklists.

### Suggested Implementation Steps
1. Explore the existing compliance-audit skill files to understand current capabilities.
2. Research what compliance frameworks are referenced in the skill's checklists.
3. Create `skills/compliance-audit/SKILL.md` following the template from other skills.
4. Include sections: Purpose, Supported Frameworks, Usage, Output Format, Examples.

### Files to Modify
- `skills/compliance-audit/SKILL.md` (create)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh --skill compliance-audit` to verify no breakage.
- Manually review the markdown rendering.

---

## Issue 6: Create Integration Test for Full Orchestrator Pipeline

| Field | Value |
|-------|-------|
| **Skill Area** | `orchestration` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-orchestration` |

### Description
The orchestrator coordinates multiple skills in sequence, but there is no end-to-end integration test that runs the full pipeline from start to finish. Create an integration test that executes the orchestrator with all five skills, validates each stage produces expected output, and verifies the final consolidated report.

### Expected Outcome
A new integration test script at `tests/orchestration/test-full-pipeline.sh` that runs the complete orchestrator pipeline and asserts correct behavior at each stage. The test should be idempotent and clean up after itself.

### Suggested Implementation Steps
1. Read the orchestrator entry point (`skills/orchestration/run.sh`) to understand pipeline flow.
2. Read existing unit tests to understand the test framework and conventions.
3. Create `tests/orchestration/test-full-pipeline.sh`.
4. The test should: run orchestrator, capture output at each stage, verify stage artifacts exist, verify consolidated report is well-formed.
5. Add cleanup logic (trap on EXIT).
6. Register the test in `tests/run-skill-tests.sh`.

### Files to Modify
- `tests/orchestration/test-full-pipeline.sh` (create)
- `tests/run-skill-tests.sh` (add integration test invocation)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh --skill orchestration` and confirm the integration test passes.
- Intentionally break one skill to verify the test catches the failure.