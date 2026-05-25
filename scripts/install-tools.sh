#!/bin/bash
# Install security tools (platform-agnostic stubs)

echo "CyberSecurity Superpowers - Tool Installation Guide"
echo ""
echo "This script provides instructions for installing security tools."
echo "Tools are not bundled - install what your project needs."
echo ""

# Python tools
echo "=== Python Tools ==="
echo "pip install bandit semgrep pip-audit gitleaks"
echo ""

# Node tools
echo "=== Node Tools ==="
echo "npm install -g eslint"
echo ""

# System tools
echo "=== System Tools ==="
echo "brew install gitleaks git-secrets  # macOS"
echo "apt install gitleaks git-secrets   # Linux"
echo ""

# Running tools
echo "=== Running Tools ==="
echo "bandit -r . -f json -o bandit-report.json"
echo "semgrep --config=auto --output=semgrep-results.sarif"
echo "gitleaks detect --source=. --verbose -f json"
echo ""

echo "See individual skill directories for tool configs."