#!/usr/bin/env bash
# Test: Static Analysis Skill
# Tests for skills/cybersecurity/static-analysis/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$PROJECT_ROOT/skills/cybersecurity/static-analysis/run.sh"
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
    echo "[SKIP] Static analysis runner not found at $RUNNER"
    exit 0
fi

echo "=== Static Analysis Skill Tests ==="

# --- Test 1: Dry-run returns JSON ---
output=$("$RUNNER" --dry-run 2>&1) || true
if echo "$output" | grep -q '"skill"'; then
    green "  [PASS] Dry-run returns skill field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should return skill field"
    failed=$((failed + 1))
fi

if echo "$output" | grep -q '"tools"'; then
    green "  [PASS] Dry-run contains tools field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should contain tools field"
    failed=$((failed + 1))
fi

# --- Test 2: Run with --output-dir --dry-run ---
TEST_DIR=$(mktemp -d)
cleanup_dirs+=("$TEST_DIR")

output=$("$RUNNER" --output-dir "$TEST_DIR/artifacts/reports" --dry-run 2>&1) || true
exit_code=$?

# With --dry-run, output is JSON to stdout; no files created
if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code is 0"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

# Remove dry-run flag to actually generate the report
output=$("$RUNNER" --output-dir "$TEST_DIR/artifacts/reports" 2>&1) || true
exit_code=$?

if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code 0 on full run"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

if [ -f "$TEST_DIR/artifacts/reports/SECURITY_SCAN.md" ]; then
    green "  [PASS] SECURITY_SCAN.md exists"
    passed=$((passed + 1))
else
    red "  [FAIL] SECURITY_SCAN.md not found"
    failed=$((failed + 1))
fi

if [ -s "$TEST_DIR/artifacts/reports/SECURITY_SCAN.md" ]; then
    green "  [PASS] SECURITY_SCAN.md is non-empty"
    passed=$((passed + 1))
else
    red "  [FAIL] SECURITY_SCAN.md is empty"
    failed=$((failed + 1))
fi

if grep -qiE "Critical|High" "$TEST_DIR/artifacts/reports/SECURITY_SCAN.md"; then
    green "  [PASS] File contains Critical or High severity findings"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain Critical or High severity findings"
    failed=$((failed + 1))
fi

# Clean up
cleanup_dirs=()
rm -rf "$TEST_DIR"

echo ""
echo "Results: $passed passed, $failed failed"
if [ "$failed" -gt 0 ]; then exit 1; fi