#!/bin/bash
# static-analysis.sh - Pre-commit hook for running static analysis / SAST
# Detects project type and runs appropriate linters:
#   JS/TS -> eslint + semgrep, Python -> bandit, Go -> gosec
# Always exits 0 (warnings only, does not block commits).
# Usage: placed in .git/hooks/pre-commit or run manually

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

RESULTS=()
HAS_FINDINGS=false

print_summary() {
  echo ""
  info "============= Static Analysis Summary ============="
  if [ ${#RESULTS[@]} -eq 0 ]; then
    ok "All checks passed."
  else
    for r in "${RESULTS[@]}"; do
      echo -e "  $r"
    done
  fi
  echo -e "${CYAN}==================================================${NC}"
}

# ---- JS/TS ----
if [ -f "package.json" ] || [ -f ".eslintrc" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ] || [ -f "eslint.config.js" ]; then
  if command -v npx &>/dev/null; then
    if npx --yes eslint --version &>/dev/null; then
      info "Running ESLint..."
      ESLINT_OUTPUT=$(npx eslint . --max-warnings=0 --format=compact 2>&1 || true)
      if echo "$ESLINT_OUTPUT" | grep -qE ":[0-9]+:[0-9]+:"; then
        HAS_FINDINGS=true
        FAIL_COUNT=$(echo "$ESLINT_OUTPUT" | grep -cE ":[0-9]+:[0-9]+:" 2>/dev/null || echo "0")
        warn "ESLint: $FAIL_COUNT issue(s) found"
        RESULTS+=("${YELLOW}ESLint${NC}: $FAIL_COUNT issue(s) (warnings only)")
        echo "$ESLINT_OUTPUT" | head -30
      else
        ok "ESLint: no issues."
        RESULTS+=("${GREEN}ESLint${NC}: clean")
      fi
    else
      warn "ESLint not available. Skipping."
    fi

    # semgrep
    if command -v semgrep &>/dev/null; then
      info "Running semgrep..."
      SEMGREP_OUTPUT=$(semgrep --metrics=off --quiet --error --config=auto . 2>&1 || true)
      if echo "$SEMGREP_OUTPUT" | grep -qiE "finding|error|warning"; then
        HAS_FINDINGS=true
        warn "semgrep found issues."
        RESULTS+=("${YELLOW}semgrep${NC}: findings (warnings only)")
        echo "$SEMGREP_OUTPUT" | head -20
      else
        ok "semgrep: clean."
        RESULTS+=("${GREEN}semgrep${NC}: clean")
      fi
    else
      info "semgrep not installed. Skipping."
    fi
  else
    warn "npx not found. Skipping JS/TS analysis."
  fi
fi

# ---- Python ----
if [ -f "*.py" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -d "python" ] || ls *.py &>/dev/null 2>&1; then
  if command -v bandit &>/dev/null; then
    info "Running bandit..."
    BANDIT_OUTPUT=$(bandit -r . -f json 2>&1 || true)
    BANDIT_COUNT=$(echo "$BANDIT_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('results',[])))" 2>/dev/null || echo "0")
    if [ "$BANDIT_COUNT" -gt 0 ] 2>/dev/null; then
      HAS_FINDINGS=true
      warn "bandit: $BANDIT_COUNT issue(s) found"
      RESULTS+=("${YELLOW}bandit${NC}: $BANDIT_COUNT issue(s) (warnings only)")
      echo "$BANDIT_OUTPUT" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d.get('results',[]):
    print(f'  {r.get(\"filename\",\"?\")}:{r.get(\"line_number\",\"?\")} - {r.get(\"test_id\",\"?\")} - {r.get(\"issue_text\",\"?\")}')
" 2>/dev/null | head -20
    else
      ok "bandit: clean."
      RESULTS+=("${GREEN}bandit${NC}: clean")
    fi
  else
    info "bandit not installed. Skipping Python analysis."
  fi
fi

# ---- Go ----
if [ -f "go.mod" ]; then
  if command -v gosec &>/dev/null; then
    info "Running gosec..."
    GOSEC_OUTPUT=$(gosec -quiet -fmt=json ./... 2>&1 || true)
    GOSEC_COUNT=$(echo "$GOSEC_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('Issues',[])))" 2>/dev/null || echo "0")
    if [ "$GOSEC_COUNT" -gt 0 ] 2>/dev/null; then
      HAS_FINDINGS=true
      warn "gosec: $GOSEC_COUNT issue(s) found"
      RESULTS+=("${YELLOW}gosec${NC}: $GOSEC_COUNT issue(s) (warnings only)")
      echo "$GOSEC_OUTPUT" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for i in d.get('Issues',[]):
    print(f'  {i.get(\"file\",\"?\")}:{i.get(\"line\",\"?\")} - {i.get(\"severity\",\"?\")} - {i.get(\"details\",\"?\")}')
" 2>/dev/null | head -20
    else
      ok "gosec: clean."
      RESULTS+=("${GREEN}gosec${NC}: clean")
    fi
  else
    info "gosec not installed. Skipping Go analysis."
  fi
fi

print_summary

if [ "$HAS_FINDINGS" = true ]; then
  warn "Static analysis found issues (non-blocking - warnings only)."
fi

exit 0