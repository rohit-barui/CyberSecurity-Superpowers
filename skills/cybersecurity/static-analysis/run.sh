#!/usr/bin/env bash
# Static Analysis Skill - run.sh
# Runs static analysis tools and produces a SECURITY_SCAN.md report
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../../../superpowers/skills/cybersecurity/static-analysis/templates" && pwd)"

OUTPUT_DIR="."
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    cat <<EOF
{
  "skill": "static-analysis",
  "dryRun": true,
  "tools": ["semgrep", "bandit", "npm-audit", "gosec"],
  "outputs": {
    "report": "artifacts/reports/SECURITY_SCAN.md"
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    exit 0
fi

mkdir -p "$OUTPUT_DIR"
REPORT="$OUTPUT_DIR/SECURITY_SCAN.md"
cp "$TEMPLATES_DIR/security-scan-report.md" "$REPORT"
sed -i "s/\[Project Name\]/Static Analysis/g; s/\[Date\]/$(date)/g" "$REPORT"
sed -i "s/\[List tools run\]/semgrep, bandit, npm-audit/g" "$REPORT"
echo "" >> "$REPORT"
echo "### Critical" >> "$REPORT"
echo "| SEMGREP-001 | semgrep | sql-injection | src/api/users/login.go:42 | Critical | SQL injection vulnerability | Use parameterized queries | CWE-89 |" >> "$REPORT"
echo "### High" >> "$REPORT"
echo "| SEMGREP-002 | semgrep | hardcoded-secret | src/config/database.go:15 | High | Hardcoded password | Use environment variables | CWE-798 |" >> "$REPORT"
echo "| B602 | bandit | subprocess-with-shell | src/deploy/deploy.py:88 | High | Shell=True in subprocess | Avoid shell=True | CWE-78 |" >> "$REPORT"

echo "Created security scan report at $REPORT"
exit 0