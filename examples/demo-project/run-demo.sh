#!/bin/bash
# Run the full security suite against the demo project
set -euo pipefail

REPORTS_DIR="artifacts/reports"
mkdir -p "$REPORTS_DIR"

echo "=== Running Threat Modeling ==="
bash skills/cybersecurity/threat-modeling/run.sh --project "Demo App" --output-dir "$REPORTS_DIR"

echo "=== Running Secure Coding ==="
bash skills/cybersecurity/secure-coding/run.sh --language javascript --target-dir examples/demo-project --output-dir "$REPORTS_DIR"

echo "=== Running Static Analysis ==="
bash skills/cybersecurity/static-analysis/run.sh --target-dir examples/demo-project --output-dir "$REPORTS_DIR" --dry-run

echo ""
echo "=== Verifying Reports ==="

THREAT_REPORT="$REPORTS_DIR/threat-modeling-report.json"
SECURE_REPORT="$REPORTS_DIR/secure-coding-report.json"
STATIC_REPORT="$REPORTS_DIR/static-analysis-report.json"

ALL_EXIST=true

for report in "$THREAT_REPORT" "$SECURE_REPORT" "$STATIC_REPORT"; do
  if [ -f "$report" ]; then
    echo "  [OK] $report"
  else
    echo "  [MISSING] $report"
    ALL_EXIST=false
  fi
done

echo ""
echo "=== Summary ==="
printf "%-25s | %-10s | %s\n" "Report" "Status" "Path"
printf "%-25s-+-%-10s-+-%s\n" "-------------------------" "----------" "---------------------------"
printf "%-25s | %-10s | %s\n" "Threat Modeling"      "$([ -f "$THREAT_REPORT" ] && echo "PASS" || echo "FAIL")" "$THREAT_REPORT"
printf "%-25s | %-10s | %s\n" "Secure Coding"        "$([ -f "$SECURE_REPORT" ] && echo "PASS" || echo "FAIL")" "$SECURE_REPORT"
printf "%-25s | %-10s | %s\n" "Static Analysis"      "$([ -f "$STATIC_REPORT" ] && echo "PASS" || echo "FAIL")" "$STATIC_REPORT"

if [ "$ALL_EXIST" = true ]; then
  echo ""
  echo "All reports generated successfully."
  exit 0
else
  echo ""
  echo "Some reports are missing."
  exit 1
fi