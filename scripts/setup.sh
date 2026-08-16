#!/usr/bin/env bash
# Setup script - verify environment and initialize directories
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "============================================"
echo "  Cybersecurity Superpowers - Setup"
echo "============================================"
echo ""

# ------------------------------------------------------------------
# 1. Verify directory structure
# ------------------------------------------------------------------
echo "1. Checking directory structure..."
DIRS=(
  "skills/cybersecurity/threat-modeling"
  "skills/cybersecurity/secure-coding"
  "skills/cybersecurity/static-analysis"
  "skills/cybersecurity/penetration-testing"
  "skills/cybersecurity/incident-response"
  "scripts"
  "hooks/pre-commit"
  "hooks/pre-push"
  "tests/skills"
  "tests/integration"
  "tests/security"
)

ALL_DIRS_OK=true
for d in "${DIRS[@]}"; do
  full="$REPO_ROOT/$d"
  if [ -d "$full" ]; then
    echo "  ✅ $d"
  else
    echo "  ❌ $d (missing)"
    ALL_DIRS_OK=false
  fi
done

if [ "$ALL_DIRS_OK" = true ]; then
  echo "  All required directories present."
fi
echo ""

# ------------------------------------------------------------------
# 2. Check tool availability
# ------------------------------------------------------------------
echo "2. Checking tool availability..."
TOOLS=(
  "bash"
  "semgrep"
  "bandit"
  "gosec"
  "npm"
  "gitleaks"
  "trivy"
)

AVAILABLE=()
MISSING=()

for tool in "${TOOLS[@]}"; do
  if command -v "$tool" &> /dev/null; then
    echo "  ✅ $tool found"
    AVAILABLE+=("$tool")
  else
    echo "  ⚠️  $tool not found (optional)"
    MISSING+=("$tool")
  fi
done
echo ""

# ------------------------------------------------------------------
# 3. Initialize artifact directories
# ------------------------------------------------------------------
echo "3. Initializing artifact directories..."
mkdir -p "$REPO_ROOT/artifacts/reports"
mkdir -p "$REPO_ROOT/artifacts/sbom"
echo "  ✅ artifacts/reports/"
echo "  ✅ artifacts/sbom/"
echo ""

# ------------------------------------------------------------------
# 4. Summary
# ------------------------------------------------------------------
echo "============================================"
echo "  Setup Summary"
echo "============================================"
echo "  Directories:    ${#DIRS[@]} checked ($([ "$ALL_DIRS_OK" = true ] && echo 'all OK' || echo 'some missing'))"
echo "  Tools available: ${#AVAILABLE[@]}/${#TOOLS[@]}"
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  Missing tools:  ${MISSING[*]}"
fi
echo "  Reports dir:    artifacts/reports/"
echo "  SBOM dir:       artifacts/sbom/"
echo "============================================"
echo ""
echo "Setup complete. (informational only - exit 0)"

exit 0