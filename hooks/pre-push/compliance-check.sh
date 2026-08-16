#!/bin/bash
# compliance-check.sh - Pre-push hook for compliance validation
# Checks for required compliance files (SECURITY.md, THREAT_MODEL.md, SBOM),
# verifies artifacts/reports/ contents, validates VERSION semver.
# Blocks push if critical items fail.
# Usage: placed in .git/hooks/pre-push or run manually

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; }

HEADER() { echo -e "\n${CYAN}==== $1 ====${NC}"; }

BLOCK_PUSH=false
CRITICAL_ITEMS=()
WARN_ITEMS=()

HEADER "Compliance Checklist"

# ---- 1. SECURITY.md ----
info "Checking SECURITY.md..."
if [ -f "SECURITY.md" ]; then
  ok "SECURITY.md found."
  if grep -qiE "report|contact|disclosure|policy" "SECURITY.md"; then
    ok "  - Contains security reporting policy."
  else
    warn "  - Missing reporting/disclosure policy content."
    WARN_ITEMS+=("SECURITY.md missing reporting policy")
  fi
else
  fail "SECURITY.md not found."
  CRITICAL_ITEMS+=("SECURITY.md")
fi

# ---- 2. THREAT_MODEL.md ----
info "Checking THREAT_MODEL.md..."
if [ -f "THREAT_MODEL.md" ]; then
  ok "THREAT_MODEL.md found."
else
  warn "THREAT_MODEL.md not found (consider generating one)."
  WARN_ITEMS+=("THREAT_MODEL.md")
fi

# ---- 3. SBOM ----
info "Checking SBOM..."
SBOM_FOUND=false
for sbom in artifacts/sbom/*.json artifacts/sbom/*.spdx artifacts/sbom/*.cdx artifacts/sbom/*.xml; do
  if [ -f "$sbom" ]; then
    ok "SBOM found: $sbom"
    SBOM_FOUND=true
    break
  fi
done
if [ "$SBOM_FOUND" = false ]; then
  warn "No SBOM found in artifacts/sbom/. Consider generating one."
  WARN_ITEMS+=("SBOM (artifacts/sbom/)")
fi

# ---- 4. artifacts/reports/ ----
info "Checking artifacts/reports/..."
if [ -d "artifacts/reports" ]; then
  REPORT_COUNT=$(find "artifacts/reports" -type f | wc -l)
  if [ "$REPORT_COUNT" -gt 0 ]; then
    ok "artifacts/reports/ contains $REPORT_COUNT file(s)."
    find "artifacts/reports" -type f -name "*.md" -o -name "*.json" -o -name "*.html" -o -name "*.txt" 2>/dev/null | while read -r r; do
      echo "  - $(basename "$r")"
    done
  else
    warn "artifacts/reports/ is empty."
    WARN_ITEMS+=("artifacts/reports/ is empty")
  fi
else
  warn "artifacts/reports/ directory does not exist."
  WARN_ITEMS+=("artifacts/reports/ directory")
fi

# ---- 5. VERSION ----
info "Checking VERSION..."
if [ -f "VERSION" ]; then
  VERSION=$(cat "VERSION" | tr -d '[:space:]')
  if echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'; then
    ok "VERSION file valid semver: $VERSION"
  else
    warn "VERSION file does not contain valid semver (got: '$VERSION')"
    WARN_ITEMS+=("VERSION invalid semver")
  fi
else
  warn "VERSION file not found."
  WARN_ITEMS+=("VERSION file")
fi

# ---- 6. Additional compliance artifacts ----
info "Checking additional compliance artifacts..."
ADDITIONAL_FILES=("COMPLIANCE_REPORT.md" "LICENSE" "README.md")
for f in "${ADDITIONAL_FILES[@]}"; do
  if [ -f "$f" ]; then
    ok "$f exists."
  else
    warn "$f not found."
    WARN_ITEMS+=("$f")
  fi
done

# ---- Summary ----
echo ""
HEADER "Compliance Summary"
echo ""

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

if [ ${#CRITICAL_ITEMS[@]} -eq 0 ]; then
  echo -e "  Critical items: ${GREEN}0${NC}"
else
  echo -e "  Critical items: ${RED}${#CRITICAL_ITEMS[@]}${NC}"
  for item in "${CRITICAL_ITEMS[@]}"; do
    echo -e "    ${RED}[FAIL]${NC} $item"
  done
fi

if [ ${#WARN_ITEMS[@]} -eq 0 ]; then
  echo -e "  Warnings:       ${GREEN}0${NC}"
else
  echo -e "  Warnings:       ${YELLOW}${#WARN_ITEMS[@]}${NC}"
  for item in "${WARN_ITEMS[@]}"; do
    echo -e "    ${YELLOW}[WARN]${NC} $item"
  done
fi

echo ""
if [ ${#CRITICAL_ITEMS[@]} -gt 0 ]; then
  fail "Compliance check FAILED - critical items missing."
  echo -e "${YELLOW}  Address all critical items before pushing.${NC}"
  exit 1
fi

ok "Compliance check PASSED."
exit 0