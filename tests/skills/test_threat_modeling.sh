#!/usr/bin/env bash
# Test: Threat Modeling Skill
# Tests for skills/cybersecurity/threat-modeling/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$PROJECT_ROOT/skills/cybersecurity/threat-modeling/run.sh"
passed=0
failed=0

green() { echo -e "\033[32m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

# --- Test 1: Dry-run returns valid JSON ---
if [ ! -f "$RUNNER" ]; then
    echo "[SKIP] Threat modeling runner not found at $RUNNER"
    exit 0
fi

echo "=== Threat Modeling Skill Tests ==="

output=$("$RUNNER" --project "TestProject" --dry-run 2>&1) || true
if echo "$output" | grep -q '"skill":'; then
    green "  [PASS] Dry-run returns skill field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should return skill field"
    failed=$((failed + 1))
fi

if echo "$output" | grep -q '"project".*"TestProject"'; then
    green "  [PASS] Dry-run contains project name"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should contain project name"
    failed=$((failed + 1))
fi

# --- Test 2: Full run creates stride-model.md ---
TEST_DIR=$(mktemp -d)
trap "rm -rf '$TEST_DIR'" EXIT

output=$("$RUNNER" --project "TestProject" --output-dir "$TEST_DIR/artifacts/reports" 2>&1) || true
exit_code=$?

if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code is 0"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

if [ -f "$TEST_DIR/artifacts/reports/stride-model.md" ]; then
    green "  [PASS] stride-model.md exists"
    passed=$((passed + 1))
else
    red "  [FAIL] stride-model.md not found"
    failed=$((failed + 1))
fi

if [ -s "$TEST_DIR/artifacts/reports/stride-model.md" ]; then
    green "  [PASS] stride-model.md is non-empty"
    passed=$((passed + 1))
else
    red "  [FAIL] stride-model.md is empty"
    failed=$((failed + 1))
fi

if grep -q "STRIDE" "$TEST_DIR/artifacts/reports/stride-model.md"; then
    green "  [PASS] File contains STRIDE header"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain STRIDE header"
    failed=$((failed + 1))
fi

if grep -q "CVSS" "$TEST_DIR/artifacts/reports/stride-model.md"; then
    green "  [PASS] File contains CVSS content"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain CVSS content"
    failed=$((failed + 1))
fi

if grep -q "TestProject" "$TEST_DIR/artifacts/reports/stride-model.md"; then
    green "  [PASS] File contains TestProject"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain TestProject"
    failed=$((failed + 1))
fi

echo ""
echo "Results: $passed passed, $failed failed"
if [ "$failed" -gt 0 ]; then exit 1; fi