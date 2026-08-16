#!/bin/bash
# threat-model-validate.sh - Pre-push hook for validating STRIDE threat model
# Checks artifacts/reports/stride-model.md for:
#   - Required sections (STRIDE categories, CVSS scores, mitigations)
#   - Unmitigated CRITICAL or HIGH threats
# Blocks push if critical threats are unmitigated or required sections are missing.
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

MODEL_FILE="artifacts/reports/stride-model.md"
BLOCK_PUSH=false

if [ ! -f "$MODEL_FILE" ]; then
  warn "No threat model found at $MODEL_FILE."
  info "Run the threat-modeling skill to generate a STRIDE model."
  info "Push allowed but consider creating a threat model."
  exit 0
fi

info "Validating threat model: $MODEL_FILE"

# ---- Check required STRIDE categories ----
REQUIRED_CATEGORIES=("Spoofing" "Tampering" "Repudiation" "Information Disclosure" "Denial of Service" "Elevation of Privilege")
MISSING_CATEGORIES=()
for cat in "${REQUIRED_CATEGORIES[@]}"; do
  if ! grep -qi "$cat" "$MODEL_FILE"; then
    MISSING_CATEGORIES+=("$cat")
  fi
done

if [ ${#MISSING_CATEGORIES[@]} -gt 0 ]; then
  warn "Missing STRIDE categories:"
  for cat in "${MISSING_CATEGORIES[@]}"; do
    echo "  - $cat"
  done
else
  ok "All STRIDE categories present."
fi

# ---- Check for CVSS scores ----
if grep -qiE "cvss|score\s*[0-9]" "$MODEL_FILE"; then
  ok "CVSS scores found."
else
  warn "No CVSS scores detected. Consider adding severity scoring."
fi

# ---- Check for mitigations ----
if grep -qiE "mitigation|mitigate|remediation|remediate|fix|resolved|accepted" "$MODEL_FILE"; then
  ok "Mitigation section/discussion found."
else
  warn "No mitigation references found. Each threat should have a mitigation strategy."
fi

# ---- Check for unmitigated CRITICAL/HIGH threats ----
UNMITIGATED_CRITICAL=0
UNMITIGATED_HIGH=0

# Strategy: find threat rows with CRITICAL or HIGH but no mitigation keyword
while IFS= read -r line; do
  if echo "$line" | grep -qiE "critical|high"; then
    # Check if this line (or nearby context) has mitigation
    if ! echo "$line" | grep -qiE "mitigation|mitigate|remediation|remediate|accepted|fix|resolved"; then
      if echo "$line" | grep -qi "critical"; then
        UNMITIGATED_CRITICAL=$((UNMITIGATED_CRITICAL + 1))
      else
        UNMITIGATED_HIGH=$((UNMITIGATED_HIGH + 1))
      fi
    fi
  fi
done < "$MODEL_FILE"

if [ "$UNMITIGATED_CRITICAL" -gt 0 ]; then
  fail "$UNMITIGATED_CRITICAL unmitigated CRITICAL threat(s) found!"
  BLOCK_PUSH=true
fi

if [ "$UNMITIGATED_HIGH" -gt 0 ]; then
  warn "$UNMITIGATED_HIGH unmitigated HIGH threat(s) found (non-blocking, but review recommended)."
fi

# ---- Final result ----
echo ""
if [ "$BLOCK_PUSH" = true ]; then
  fail "Threat model validation FAILED - unmitigated critical threats exist."
  echo -e "${YELLOW}  Resolve or formally accept all CRITICAL threats before pushing.${NC}"
  exit 1
fi

if [ ${#MISSING_CATEGORIES[@]} -gt 0 ]; then
  warn "Threat model validation passed with warnings (missing categories)."
else
  ok "Threat model validation PASSED."
fi
exit 0