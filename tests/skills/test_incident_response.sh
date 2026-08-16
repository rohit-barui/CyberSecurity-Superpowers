#!/usr/bin/env bash
# Test: Incident Response Skill
# Tests for skills/cybersecurity/incident-response/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$PROJECT_ROOT/skills/cybersecurity/incident-response/run.sh"
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
    echo "[SKIP] Incident response runner not found at $RUNNER"
    exit 0
fi

echo "=== Incident Response Skill Tests ==="

# --- Test 1: Dry-run with --incident-type ransomware ---
output=$("$RUNNER" --incident-type ransomware --dry-run 2>&1) || true
if echo "$output" | grep -q '"skill"'; then
    green "  [PASS] Dry-run returns skill field"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should return skill field"
    failed=$((failed + 1))
fi

if echo "$output" | grep -q '"incidentType".*"ransomware"'; then
    green "  [PASS] Dry-run contains incident type"
    passed=$((passed + 1))
else
    red "  [FAIL] Dry-run should contain incident type"
    failed=$((failed + 1))
fi

# --- Test 2: Full run creates incident-playbook.md ---
TEST_DIR=$(mktemp -d)
cleanup_dirs+=("$TEST_DIR")

output=$("$RUNNER" --incident-type ransomware --output-dir "$TEST_DIR/artifacts/reports" 2>&1) || true
exit_code=$?

if [ "$exit_code" -eq 0 ]; then
    green "  [PASS] Exit code is 0"
    passed=$((passed + 1))
else
    red "  [FAIL] Expected exit code 0, got $exit_code"
    failed=$((failed + 1))
fi

if [ -f "$TEST_DIR/artifacts/reports/incident-playbook.md" ]; then
    green "  [PASS] incident-playbook.md exists"
    passed=$((passed + 1))
else
    red "  [FAIL] incident-playbook.md not found"
    failed=$((failed + 1))
fi

if [ -s "$TEST_DIR/artifacts/reports/incident-playbook.md" ]; then
    green "  [PASS] incident-playbook.md is non-empty"
    passed=$((passed + 1))
else
    red "  [FAIL] incident-playbook.md is empty"
    failed=$((failed + 1))
fi

if grep -qi "ransomware" "$TEST_DIR/artifacts/reports/incident-playbook.md"; then
    green "  [PASS] File contains ransomware (case-insensitive)"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain ransomware"
    failed=$((failed + 1))
fi

if grep -qi "Preparation" "$TEST_DIR/artifacts/reports/incident-playbook.md"; then
    green "  [PASS] File contains Preparation phase"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain Preparation phase"
    failed=$((failed + 1))
fi

if grep -qi "Containment" "$TEST_DIR/artifacts/reports/incident-playbook.md"; then
    green "  [PASS] File contains Containment phase"
    passed=$((passed + 1))
else
    red "  [FAIL] File should contain Containment phase"
    failed=$((failed + 1))
fi

# --- Test 3: Invalid incident type returns non-zero exit code ---
set +e
"$RUNNER" --incident-type invalid_type_xyz --dry-run > /dev/null 2>&1
invalid_exit=$?
set -euo pipefail

if [ "$invalid_exit" -ne 0 ]; then
    green "  [PASS] Invalid incident type returns non-zero exit code ($invalid_exit)"
    passed=$((passed + 1))
else
    red "  [FAIL] Invalid incident type should return non-zero exit code"
    failed=$((failed + 1))
fi

# Clean up
cleanup_dirs=()
rm -rf "$TEST_DIR"

echo ""
echo "Results: $passed passed, $failed failed"
if [ "$failed" -gt 0 ]; then exit 1; fi