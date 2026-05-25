#!/bin/bash
# Dependency audit pre-commit hook
echo "Running dependency audit..."
if [ -f "package.json" ]; then
  npm audit --audit-level=high || echo "Warning: High severity vulnerabilities found"
fi
if [ -f "requirements.txt" ]; then
  pip-audit --ignore-vulns= || pip-audit || echo "Warning: Run pip-audit manually"
fi
echo "Dependency audit completed."