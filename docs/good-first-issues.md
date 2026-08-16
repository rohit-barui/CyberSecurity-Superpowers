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
The secure-coding skill currently includes security checklists for JavaScript, TypeScript, Python, Go, and Rust but is missing Java. Add a new checklist file covering common Java security vulnerabilities including SQL injection (prepared statements), deserialization attacks, insecure reflection, XXE, and improper logging of sensitive data.

### Expected Outcome
A new file `skills/cybersecurity/secure-coding/checklists/java.md` containing a structured security checklist for Java development. The file should follow the same format as existing checklists (e.g., `python.md`).

### Suggested Implementation Steps
1. Read the existing checklists in `skills/cybersecurity/secure-coding/checklists/` to understand the format.
2. Research OWASP Java-specific vulnerabilities (SQL injection, deserialization, XXE, etc.).
3. Create `skills/cybersecurity/secure-coding/checklists/java.md` following the same template.
4. Update `skills/cybersecurity/secure-coding/SKILL.md` to reference the new checklist.

### Files to Modify
- `skills/cybersecurity/secure-coding/checklists/java.md` (create)
- `skills/cybersecurity/secure-coding/SKILL.md` (update references)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh` to verify existing tests still pass.
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
A new test file in `tests/skills/` that validates SARIF output correctness. The test should catch malformed output, missing required fields, and structural errors.

### Suggested Implementation Steps
1. Study the SARIF v2.1.0 specification (OASIS standard).
2. Read the current test infrastructure in `tests/run-skill-tests.sh`.
3. Create `tests/skills/test-sarif-output.sh`.
4. Use `jq` to validate JSON structure against expected SARIF fields.
5. Integrate the test into `tests/run-skill-tests.sh`.

### Files to Modify
- `tests/skills/test-sarif-output.sh` (create)
- `tests/run-skill-tests.sh` (add test invocation)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh` to confirm the new test passes.
- Intentionally break the SARIF output to ensure the test fails correctly.

---

## Issue 3: Add "malware-infection" Incident Type to Incident-Response Skill

| Field | Value |
|-------|-------|
| **Skill Area** | `incident-response` |
| **Difficulty** | Easy |
| **Labels** | `good-first-issue`, `skill-incident-response` |

### Description
The incident-response skill supports predefined incident types (`ransomware`, `data-breach`, `phishing`, `ddos`, `insider-threat`) but not `malware-infection`. Add this incident type with a corresponding playbook section following the existing pattern in `run.sh`.

### Expected Outcome
Users can invoke `bash skills/cybersecurity/incident-response/run.sh --incident-type malware-infection` and receive a full incident response workflow covering detection, containment, eradication, and recovery for malware infections.

### Suggested Implementation Steps
1. Read `skills/cybersecurity/incident-response/run.sh` to understand the `get_procedures()` function pattern.
2. Add a new `malware-infection)` case block in the `get_procedures()` function with all 6 NIST phases.
3. Add the severity mapping for the new type.
4. Update `skills/cybersecurity/incident-response/SKILL.md` to list the new incident type.

### Files to Modify
- `skills/cybersecurity/incident-response/run.sh` (add procedures, severity, valid types list)
- `skills/cybersecurity/incident-response/SKILL.md` (update type list)

### Testing Guidance
- Run `bash skills/cybersecurity/incident-response/run.sh --incident-type malware-infection` and verify the output.
- Run `bash tests/run-skill-tests.sh` to ensure no regressions.

---

## Issue 4: Implement `--severity-threshold` Flag for Static-Analysis run.sh

| Field | Value |
|-------|-------|
| **Skill Area** | `static-analysis` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-static-analysis` |

### Description
The `skills/cybersecurity/static-analysis/run.sh` script currently reports all findings regardless of severity. Add a `--severity-threshold` flag that filters results to only show findings at or above a specified severity level (e.g., `--severity-threshold high` shows only high and critical findings). Supported levels: `low`, `medium`, `high`, `critical`.

### Expected Outcome
Users can run `bash skills/cybersecurity/static-analysis/run.sh --severity-threshold high` and only see findings with severity "high" or "critical". The flag must be documented in `--help` output.

### Suggested Implementation Steps
1. Read `skills/cybersecurity/static-analysis/run.sh` to understand argument parsing and output logic.
2. Add `--severity-threshold` with a default of `low` (show everything).
3. Implement filtering logic after analysis runs in both markdown and JSON report generators.
4. Update `--help` output to document the new flag.
5. Add tests for the new flag behavior.

### Files to Modify
- `skills/cybersecurity/static-analysis/run.sh` (add flag, filtering, help text)
- `tests/skills/test_static_analysis.sh` (add threshold tests)

### Testing Guidance
- Run with `--severity-threshold critical` and confirm only critical findings appear.
- Run with `--severity-threshold low` and confirm all findings appear.
- Verify `--help` shows the new flag.

---

## Issue 5: Create Supply-Chain Security Skill run.sh

| Field | Value |
|-------|-------|
| **Skill Area** | `supply-chain-security` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-supply-chain` |

### Description
The supply-chain-security skill has a `SKILL.md` and `templates/` but is missing a `run.sh` script. Currently, SBOM generation is done via `scripts/generate-sbom.sh`. This issue is to create `skills/cybersecurity/supply-chain-security/run.sh` that wraps the generate-sbom.sh script with the same interface as other skills, enabling the orchestrator to invoke it consistently.

### Expected Outcome
A new `skills/cybersecurity/supply-chain-security/run.sh` that accepts `--target-dir`, `--output-dir`, and `--dry-run` flags, delegates to `scripts/generate-sbom.sh`, and provides the standard skill interface.

### Suggested Implementation Steps
1. Read `scripts/generate-sbom.sh` to understand its CLI interface.
2. Read an existing skill's `run.sh` (e.g., `skills/cybersecurity/threat-modeling/run.sh`) for the standard pattern.
3. Create `skills/cybersecurity/supply-chain-security/run.sh` that wraps generate-sbom.sh.
4. Pass through all flags appropriately.

### Files to Modify
- `skills/cybersecurity/supply-chain-security/run.sh` (create)

### Testing Guidance
- Run `bash skills/cybersecurity/supply-chain-security/run.sh --target-dir . --dry-run` and verify JSON metadata output.
- Run `bash tests/run-skill-tests.sh` to ensure no regressions.

---

## Issue 6: Create Integration Test for Full Orchestrator Pipeline

| Field | Value |
|-------|-------|
| **Skill Area** | `orchestration` |
| **Difficulty** | Medium |
| **Labels** | `good-first-issue`, `skill-orchestration` |

### Description
The orchestrator coordinates multiple skills in sequence, but there is no end-to-end integration test that runs the full pipeline from start to finish. Create an integration test that executes the orchestrator with all five skills, validates each stage produces expected output, and verifies the final artifacts.

### Expected Outcome
A new integration test script at `tests/skills/test_full_pipeline.sh` that runs the complete orchestrator pipeline and asserts correct behavior at each stage. The test should be idempotent and clean up after itself.

### Suggested Implementation Steps
1. Read the orchestrator entry point (`scripts/run-orchestrator.sh`) to understand pipeline flow.
2. Read existing skill tests in `tests/skills/` to understand the test framework and conventions.
3. Create `tests/skills/test_full_pipeline.sh`.
4. The test should: run orchestrator in `full` mode, verify each stage artifact exists, verify output content.
5. Add cleanup logic (trap on EXIT).
6. Register the test in `tests/run-skill-tests.sh`.

### Files to Modify
- `tests/skills/test_full_pipeline.sh` (create)
- `tests/run-skill-tests.sh` (add integration test invocation)

### Testing Guidance
- Run `bash tests/run-skill-tests.sh` and confirm the integration test passes.
- Intentionally break one skill to verify the test catches the failure.