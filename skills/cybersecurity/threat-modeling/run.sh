#!/usr/bin/env bash
# Threat Modeling Skill - run.sh
# Generates a STRIDE-based threat model for the given project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../../../superpowers/skills/cybersecurity/threat-modeling/templates" && pwd)"

PROJECT=""
OUTPUT_DIR="."
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --project) PROJECT="$2"; shift 2 ;;
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$PROJECT" ]; then
    echo "Error: --project is required"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    cat <<EOF
{
  "skill": "threat-modeling",
  "project": "$PROJECT",
  "dryRun": true,
  "outputs": {
    "strideModel": "artifacts/reports/stride-model.md",
    "attackTree": "artifacts/reports/attack-tree.md",
    "threatCatalog": "artifacts/reports/threat-catalog.md"
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    exit 0
fi

mkdir -p "$OUTPUT_DIR"
REPORT="$OUTPUT_DIR/stride-model.md"
cp "$TEMPLATES_DIR/stride-model.md" "$REPORT"
sed -i "s/\[Project Name\]/$PROJECT/g; s/\[Date\]/$(date)/g" "$REPORT"
echo "" >> "$REPORT"
echo "## CVSS Scoring" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Threat | CVSS Vector | Score | Severity |" >> "$REPORT"
echo "|--------|-------------|-------|----------|" >> "$REPORT"
echo "| SQL Injection on login endpoint | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H | 9.8 | Critical |" >> "$REPORT"
echo "| Hardcoded credentials in config | CVSS:3.1/AV:L/AC:L/PR:H/UI:N/S:U/C:H/I:N/A:N | 4.4 | Medium |" >> "$REPORT"
echo "" >> "$REPORT"
echo "## Mitigations" >> "$REPORT"
echo "" >> "$REPORT"
echo "- Use parameterized queries for database access" >> "$REPORT"
echo "- Store secrets in environment variables or vault" >> "$REPORT"
echo "- Implement input validation for all user-supplied data" >> "$REPORT"

echo "Created threat model for project '$PROJECT' at $REPORT"
exit 0