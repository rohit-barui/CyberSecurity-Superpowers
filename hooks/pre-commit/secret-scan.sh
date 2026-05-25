#!/bin/bash
# Secret detection pre-commit hook
echo "Running secret detection..."
if command -v git-secrets &> /dev/null; then
  git-secrets --scan --recursive || exit 1
fi
if command -v gitleaks &> /dev/null; then
  gitleaks detect --source=. --verbose -f json -r gitleaks-report.json || exit 1
fi
echo "Secret detection passed."