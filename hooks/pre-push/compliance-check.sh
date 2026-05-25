#!/bin/bash
# Compliance check pre-push hook
echo "Running compliance check..."
if [ -f "COMPLIANCE_REPORT.md" ]; then
  echo "Compliance report found."
  if grep -q "Critical\|Failed" COMPLIANCE_REPORT.md; then
    echo "Critical compliance gaps detected. Address before pushing."
    exit 1
  fi
else
  echo "No COMPLIANCE_REPORT.md found. Consider running compliance-audit."
fi
echo "Compliance check completed."