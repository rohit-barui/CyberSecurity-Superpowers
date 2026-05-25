# Secret Detection Security Tests

## Test 1: Pattern file validity
- [ ] Verify secret-patterns.yaml is valid YAML
- [ ] Verify each pattern has id, pattern, severity fields
- [ ] All patterns have valid regex (check with -r flag)
- [ ] PASS / FAIL

## Test 2: Scan regression
- [ ] Run secret detection on this repo
- [ ] Verify no actual secrets leaked in test fixtures
- [ ] Verify known test patterns are detected
- [ ] PASS / FAIL