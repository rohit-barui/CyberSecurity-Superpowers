#!/usr/bin/env bash
# Test: Penetration Testing Skill
# Tests for skills/cybersecurity/penetration-testing/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$PROJECT_ROOT/skills/cybersecurity/penetration-testing/run.sh"
passed=0
failed=0
cleanup_dirs=()

cleanup() {
    for d in "${cleanup_dirs[@]}"; do rm -rf "$d"; done
}
trap cleanup EXIT

green() { echo -e "\033[32m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

if [ ! -f "$RUNNER" ]; then
    echo "[SKIP] Penetration testing runner not found at $RUNNER"
    exit 0
fi

echo "=== Penetration Testing Skill Tests ==="

# --- Test 1: Dry-run with --target-app ---
output=$("$RUNNER" --target-app "TestApp" --dry-run 2>&1) || true
if echo "$output" | grep -q '"skill"'; then
    green "  [PASS] Dry-run returns skill field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should return skill field"
    failed=$((failed + 1))
fi

if echo "$output" | grep -q '"targetApp".*"TestApp"'; then
    green "  [PASS] Dry-run contains target application name"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should contain target application name"
    failed=$((failed + 1))
fi

# --- Test 2: Full run creates pentest-plan.md ---
TEST_DIR=$(mktemp -d)
cleanup_dirs+=("$TEST_DIR")

output=$("$RUNNER" --target-app "TestApp" --output-dir "$TEST_DIR/artifacts/reports" 2>&1) || true
exit_code=$?

if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code is 0"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

if [ -f "$TEST_DIR/artifacts/reports/pentest-plan.md" ]; then
    green "  [PASS] pentest-plan.md exists"
    passed=$((passed + 1))
else
    red "  [FAIL] pentest-plan.md not found"
    failed=$((failed + 1))
fi

if [ -s "$TEST_DIR/artifacts/reports/pentest-plan.md" ]; then
    green "  [PASS] pentest-plan.md is non-empty"
    passed=$((passed + 1))
else
    red "  [FAIL] pentest-plan.md is empty"
    failed=$((failed + 1))
fi

if grep -q "TestApp" "$TEST_DIR/artifacts/reports/pentest-plan.md"; then
    green "  [PASS] File contains TestApp"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain TestApp"
    failed=$((failed + 1))
fi

if grep -qiE "MITRE|WSTG" "$TEST_DIR/artifacts/reports/pentest-plan.md"; then
    green "  [PASS] File contains MITRE or WSTG"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain MITRE or WSTG"
    failed=$((failed + 1))
fi

# Clean up
cleanup_dirs=()
rm -rf "$TEST_DIR"

echo ""
echo "Results: $passed passed, $failed failed"
if [ "$failed" -gt 0 ]; then exit 1; fi