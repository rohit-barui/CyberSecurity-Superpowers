#!/usr/bin/env bash
# Batch security suite runner - executes all 5 cybersecurity skills
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../skills/cybersecurity"
REPORTS_DIR="$SCRIPT_DIR/../artifacts/reports"

mkdir -p "$REPORTS_DIR"

echo "============================================"
echo "  Cybersecurity Superpowers - Full Suite"
echo "============================================"
echo ""

RESULTS=()

run_check() {
  local skill="$1"
  local script="$SKILLS_DIR/$skill/run.sh"
  local flag="$2"
  local arg="$3"
  local output_file="$4"
  local name="$skill"

  printf "  %-20s ... " "$name"

  if [ ! -f "$script" ]; then
    echo "SKIP (no script)"
    RESULTS+=("$name|⚠️ SKIP|N/A")
    return
  fi

  # Each skill writes its own report; we just invoke it
  if bash "$script" "$flag" "$arg" > /dev/null 2>&1; then
    if [ -f "$output_file" ]; then
      echo "✅ PASS"
      RESULTS+=("$name|✅ PASS|$output_file")
    else
      echo "✅ PASS (report path unknown)"
      RESULTS+=("$name|✅ PASS|unknown")
    fi
  else
    echo "❌ FAIL"
    RESULTS+=("$name|❌ FAIL|N/A")
  fi
}

echo "  Executing all 5 security skills..."
echo ""

run_check "threat-modeling"      "--project"       "cybersecurity-superpowers"     "artifacts/reports/stride-model.md"
run_check "secure-coding"        "--language"      "auto"                          "artifacts/reports/SECURITY.md"
run_check "static-analysis"      "--target-dir"    "."                             "artifacts/reports/SECURITY_SCAN.md"
run_check "penetration-testing"  "--target-app"    "cybersecurity-superpowers"     "artifacts/reports/pentest-plan.md"
run_check "incident-response"    "--incident-type" "ransomware"                    "artifacts/reports/incident-playbook.md"

echo ""
echo "============================================"
echo "  Summary Table"
echo "============================================"
printf "  %-22s %-10s %s\n" "Skill" "Status" "Output File"
printf "  %-22s %-10s %s\n" "----" "------" "-----------"
ANY_FAIL=0
for r in "${RESULTS[@]}"; do
  IFS='|' read -r name status file <<< "$r"
  printf "  %-22s %-10s %s\n" "$name" "$status" "$file"
  if [[ "$status" == *"FAIL"* ]]; then
    ANY_FAIL=1
  fi
done
echo "============================================"

exit $ANY_FAIL