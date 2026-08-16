#!/bin/bash
# Run npm audit and output results to SECURITY_SCAN.md
if [ -f "package.json" ]; then
  npm audit --json > npm-audit-report.json 2>/dev/null || true
  echo "npm audit complete. Results in npm-audit-report.json"
else
  echo "No package.json found, skipping npm audit"
fi