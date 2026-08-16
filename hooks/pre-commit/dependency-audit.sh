#!/bin/bash
# dependency-audit.sh - Pre-commit hook for auditing project dependencies
# Scans package.json (npm), requirements.txt (pip), or go.mod (Go) for
# known vulnerabilities. Warns on HIGH, blocks on CRITICAL.
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

HAS_CRITICAL=false
FINDINGS=()

# ---- npm / Node.js ----
if [ -f "package.json" ]; then
  if command -v npm &>/dev/null; then
    info "Running npm audit..."
    NPM_OUTPUT=$(npm audit --json 2>/dev/null || true)
    if [ -z "$NPM_OUTPUT" ] || echo "$NPM_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('vulnerabilities',{}).get('critical',0))" 2>/dev/null | grep -q '^0$'; then
      ok "npm audit: no critical vulnerabilities."
    else
      CRIT_COUNT=$(echo "$NPM_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('vulnerabilities',{}).get('critical',0))" 2>/dev/null || echo "0")
      HIGH_COUNT=$(echo "$NPM_OUTPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('vulnerabilities',{}).get('high',0))" 2>/dev/null || echo "0")
      if [ "$CRIT_COUNT" -gt 0 ] 2>/dev/null; then
        HAS_CRITICAL=true
        fail "npm audit: $CRIT_COUNT critical, $HIGH_COUNT high vulnerabilities"
        echo "$NPM_OUTPUT" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for adv_id, adv in d.get('advisories',{}).items():
    sev=adv.get('severity','')
    if sev in ('critical','high'):
        print(f'  {sev.upper():>8} | {adv.get(\"package_name\",\"?\")} | {adv.get(\"cve\",\"N/A\")} | {adv.get(\"title\",\"?\")}')
" 2>/dev/null || echo "$NPM_OUTPUT" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for pkg, data in d.get('vulnerabilities',{}).items():
    sev=data.get('severity','')
    if sev in ('critical','high'):
        via=data.get('via',[])
        cve=''
        if via and isinstance(via,list):
            for v in via:
                if isinstance(v,dict):
                    cve=v.get('cve','N/A')
        print(f'  {sev.upper():>8} | {pkg} | {cve}')
" 2>/dev/null || true
      elif [ "$HIGH_COUNT" -gt 0 ] 2>/dev/null; then
        warn "npm audit: $HIGH_COUNT high vulnerabilities (non-blocking)"
        echo "$NPM_OUTPUT" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for pkg, data in d.get('vulnerabilities',{}).items():
    sev=data.get('severity','')
    if sev in ('critical','high'):
        via=data.get('via',[])
        cve=''
        if via and isinstance(via,list):
            for v in via:
                if isinstance(v,dict):
                    cve=v.get('cve','N/A')
        print(f'  {sev.upper():>8} | {pkg} | {cve}')
" 2>/dev/null || true
      else
        ok "npm audit: no vulnerabilities found."
      fi
    fi
  else
    warn "npm not found. Skipping npm audit."
  fi
fi

# ---- pip / Python ----
if [ -f "requirements.txt" ] || [ -f "Pipfile" ] || [ -f "pyproject.toml" ]; then
  if command -v pip-audit &>/dev/null; then
    info "Running pip-audit..."
    PIP_OUTPUT=$(pip-audit --desc 2>&1 || true)
    if echo "$PIP_OUTPUT" | grep -qi "critical\|CRITICAL"; then
      HAS_CRITICAL=true
      fail "pip-audit found critical vulnerabilities:"
      echo "$PIP_OUTPUT" | grep -iE "critical|CRITICAL" | head -20
    elif echo "$PIP_OUTPUT" | grep -qi "high\|HIGH"; then
      warn "pip-audit found high vulnerabilities (non-blocking):"
      echo "$PIP_OUTPUT" | grep -iE "high|HIGH" | head -20
    else
      ok "pip-audit: no vulnerabilities found."
    fi
  else
    warn "pip-audit not installed. Skipping Python dependency audit."
  fi
fi

# ---- Go ----
if [ -f "go.mod" ]; then
  info "Running Go module verification..."
  go mod verify 2>&1 || warn "go mod verify reported issues."
  if command -v gosec &>/dev/null; then
    info "Running gosec..."
    GOSEC_OUTPUT=$(gosec -quiet ./... 2>&1 || true)
    if echo "$GOSEC_OUTPUT" | grep -qi "critical"; then
      HAS_CRITICAL=true
      fail "gosec found critical issues:"
      echo "$GOSEC_OUTPUT" | head -20
    else
      ok "gosec: no critical issues."
    fi
  else
    warn "gosec not installed. Skipping Go security scan."
  fi
fi

if [ "$HAS_CRITICAL" = true ]; then
  fail "Critical vulnerabilities found. Commit blocked."
  exit 1
fi

ok "Dependency audit completed."
exit 0