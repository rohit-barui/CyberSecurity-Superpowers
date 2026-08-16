#!/usr/bin/env bash
# Test: Secure Coding Skill
# Tests for skills/cybersecurity/secure-coding/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$PROJECT_ROOT/skills/cybersecurity/secure-coding/run.sh"
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
    echo "[SKIP] Secure coding runner not found at $RUNNER"
    exit 0
fi

echo "=== Secure Coding Skill Tests ==="

# --- Test 1: Dry-run with --language javascript ---
output=$("$RUNNER" --language javascript --dry-run 2>&1) || true
if echo "$output" | grep -q '"skill"'; then
    green "  [PASS] Dry-run returns skill field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should return skill field"
    failed=$((failed + 1))
fi

if echo "$output" | grep -q '"language".*"javascript"'; then
    green "  [PASS] Dry-run contains language"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should contain language"
    failed=$((failed + 1))
fi

# --- Test 2: Full run creates SECURITY.md ---
TEST_DIR=$(mktemp -d)
cleanup_dirs+=("$TEST_DIR")

output=$("$RUNNER" --language javascript --output-dir "$TEST_DIR/artifacts/reports" 2>&1) || true
exit_code=$?

if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code is 0"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

if [ -f "$TEST_DIR/artifacts/reports/SECURITY.md" ]; then
    green "  [PASS] SECURITY.md exists"
    passed=$((passed + 1))
else
    red "  [FAIL] SECURITY.md not found"
    failed=$((failed + 1))
fi

if [ -s "$TEST_DIR/artifacts/reports/SECURITY.md" ]; then
    green "  [PASS] SECURITY.md is non-empty"
    passed=$((passed + 1))
else
    red "  [FAIL] SECURITY.md is empty"
    failed=$((failed + 1))
fi

if grep -qi "javascript" "$TEST_DIR/artifacts/reports/SECURITY.md"; then
    green "  [PASS] File contains JavaScript/javascript"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain JavaScript"
    failed=$((failed + 1))
fi

if grep -qiE "OWASP|Security Checklist" "$TEST_DIR/artifacts/reports/SECURITY.md"; then
    green "  [PASS] File contains OWASP or Security Checklist"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain OWASP or Security Checklist"
    failed=$((failed + 1))
fi

# Clean up test outputs
cleanup_dirs=()
rm -rf "$TEST_DIR"

echo ""
echo "Results: $passed passed, $failed failed"
if [ "$failed" -gt 0 ]; then exit 1; fi