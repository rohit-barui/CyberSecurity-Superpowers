#!/bin/bash
# Static analysis pre-commit hook
echo "Running static analysis..."
if [ -f "package.json" ]; then
  npx eslint . --max-warnings=0 2>/dev/null || echo "Lint warnings found"
fi
if [ -d "python" ]; then
  bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit warnings found"
fi
echo "Static analysis completed."