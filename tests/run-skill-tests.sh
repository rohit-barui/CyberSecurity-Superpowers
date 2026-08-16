#!/usr/bin/env bash
# Test Runner for Cybersecurity Skill Unit Tests
# Runs each tests/skills/test_*.sh script in sequence and reports results
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

total_passed=0
total_failed=0
total_skipped=0
start_time=$(date +%s)

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Cybersecurity Skill Unit Tests${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "Repository: $PROJECT_ROOT"
echo "Start time: $(date)"
echo ""

# Find all test scripts
test_files=()
for f in "$SCRIPT_DIR/skills/test_"*.sh; do
    if [ -f "$f" ]; then
        test_files+=("$f")
    fi
done

if [ ${#test_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}No test scripts found in tests/skills/${NC}"
    exit 1
fi

# Run each test
for test_file in "${test_files[@]}"; do
    test_name=$(basename "$test_file")
    echo -e "${CYAN}----------------------------------------${NC}"
    echo -e "${CYAN}  Running: $test_name${NC}"
    echo -e "${CYAN}----------------------------------------${NC}"

    test_start=$(date +%s)

    if [ ! -f "$test_file" ]; then
        echo -e "${YELLOW}  [SKIP] Test file not found: $test_file${NC}"
        total_skipped=$((total_skipped + 1))
        continue
    fi

    set +e
    output=$(bash "$test_file" 2>&1)
    exit_code=$?
    set -euo pipefail

    test_end=$(date +%s)
    test_duration=$((test_end - test_start))

    # Print the test output
    echo "$output"

    # Determine pass/fail from exit code
    # The test scripts print their own PASS/FAIL lines; we track based on exit code
    if [ "$exit_code" -eq 0 ]; then
        echo ""
        echo -e "${GREEN}  [PASS] $test_name (${test_duration}s)${NC}"
        total_passed=$((total_passed + 1))
    else
        echo ""
        echo -e "${RED}  [FAIL] $test_name (${test_duration}s)${NC}"
        total_failed=$((total_failed + 1))
    fi
    echo ""
done

# Summary
end_time=$(date +%s)
total_duration=$((end_time - start_time))

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Test Results Summary${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC}  $total_passed"
echo -e "  ${RED}Failed:${NC}  $total_failed"
echo -e "  ${YELLOW}Skipped:${NC} $total_skipped"
echo ""
echo "  Total execution time: ${total_duration}s"
echo ""

if [ "$total_failed" -gt 0 ]; then
    echo -e "${RED}STATUS: FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}STATUS: PASSED${NC}"
    exit 0
fi