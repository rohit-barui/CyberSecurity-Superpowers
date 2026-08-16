#!/bin/bash
# secret-scan.sh - Pre-commit hook for detecting secrets in staged files
# Scans staged changes for AWS keys, GitHub PATs, RSA keys, Slack webhooks,
# OpenAI keys, and generic password/API key patterns. Also runs gitleaks if available.
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

STAGED=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
if [ -z "$STAGED" ]; then
  info "No staged files to scan."
  exit 0
fi

ALLOWLIST_PATTERNS=(
  'test/'
  'tests/'
  'fixtures/'
  'spec/'
  '__tests__/'
  'mock'
  'fake-'
  '.example.'
)

should_skip() {
  local file="$1"
  for pattern in "${ALLOWLIST_PATTERNS[@]}"; do
    if echo "$file" | grep -qiE "$pattern" 2>/dev/null; then
      return 0
    fi
  done
  return 1
}

SECRET_PATTERNS=(
  'AKIA[0-9A-Z]{16}'                                                          # AWS Access Key
  'ghp_[0-9a-zA-Z]{36}'                                                       # GitHub Personal Access Token
  'gho_[0-9a-zA-Z]{36}'                                                       # GitHub OAuth Access Token
  'github_pat_[0-9a-zA-Z]{36}'                                                # GitHub Fine-Grained PAT
  '-----BEGIN RSA PRIVATE KEY-----'                                           # RSA Private Key
  '-----BEGIN OPENSSH PRIVATE KEY-----'                                       # OpenSSH Private Key
  '-----BEGIN DSA PRIVATE KEY-----'                                           # DSA Private Key
  '-----BEGIN EC PRIVATE KEY-----'                                            # EC Private Key
  'https://hooks\.slack\.com/services/T[0-9A-Z]+/B[0-9A-Z]+/[0-9a-zA-Z]+'     # Slack Webhook
  'sk-[0-9a-zA-Z]{32,}'                                                       # OpenAI API Key
  'sk-[0-9a-zA-Z]{20,}'                                                       # OpenAI Legacy Key
  'password\s*[:=]\s*['"'"'"][^'"'"'"]+['"'"'"]'                              # Generic password assignment
  'api[_-]?key\s*[:=]\s*['"'"'"][0-9a-zA-Z]{16,}['"'"'"]'                     # Generic API key
  'secret\s*[:=]\s*['"'"'"][0-9a-zA-Z]{16,}['"'"'"]'                         # Generic secret
  'token\s*[:=]\s*['"'"'"][0-9a-zA-Z]{16,}['"'"'"]'                          # Generic token
)

FOUND_ANY=false

for file in $STAGED; do
  if should_skip "$file"; then
    info "Skipping allowed file: $file"
    continue
  fi
  if [ ! -f "$file" ]; then
    continue
  fi
  line_num=0
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    for pattern in "${SECRET_PATTERNS[@]}"; do
      if echo "$line" | grep -qE "$pattern"; then
        FOUND_ANY=true
        fail "Secret pattern found in $file:$line_num"
        echo "         Pattern: ${pattern:0:60}"
        break
      fi
    done
  done < "$file"
done

if command -v gitleaks &>/dev/null; then
  info "Running gitleaks on staged files..."
  GITLEAKS_REPORT=$(mktemp)
  if gitleaks detect --source=. --verbose 2>"$GITLEAKS_REPORT"; then
    ok "gitleaks: no secrets found."
  else
    FOUND_ANY=true
    fail "gitleaks reported secrets:"
    cat "$GITLEAKS_REPORT" 2>/dev/null | head -30
  fi
  rm -f "$GITLEAKS_REPORT"
else
  info "gitleaks not installed. Skipping gitleaks scan."
fi

if [ "$FOUND_ANY" = true ]; then
  fail "Secrets detected in staged changes. Commit blocked."
  echo -e "${YELLOW}  Remove or replace secrets with placeholders before committing.${NC}"
  echo -e "${YELLOW}  If false positive, add the file to ALLOWLIST_PATTERNS in this hook.${NC}"
  exit 1
fi

ok "No secrets found in staged changes."
exit 0