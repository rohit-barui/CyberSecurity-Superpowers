# Skill Coverage Integration Tests

## Test 1: All skills discoverable
- [ ] Verify skills/ directory exists
- [ ] Verify each skill has SKILL.md with YAML frontmatter
- [ ] Expected: threat-modeling, secure-coding, static-analysis, penetration-testing, incident-response, compliance-audit, secret-detection, supply-chain-security, security-architecture
- [ ] PASS / FAIL

## Test 2: Template completeness
- [ ] Verify each skill has templates/ directory
- [ ] Verify each skill has references/ directory
- [ ] PASS / FAIL

## Test 3: Hook chain integrity
- [ ] Verify hooks/ directory with pre-commit/ and pre-push/ exists
- [ ] Verify each hook is executable (chmod +x)
- [ ] PASS / FAIL

## Test 4: Documentation completeness
- [ ] Verify docs/adr/ exists with at least 4 ADRs
- [ ] Verify docs/architecture/ exists with C4 documentation
- [ ] PASS / FAIL