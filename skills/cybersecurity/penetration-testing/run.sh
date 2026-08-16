#!/usr/bin/env bash
# Penetration Testing Skill - run.sh
# Generates a red-team penetration testing plan mapped to MITRE ATT&CK and OWASP WSTG
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../../../superpowers/skills/cybersecurity/penetration-testing/templates" && pwd)"

TARGET_APP=""
OUTPUT_DIR="."
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --target-app) TARGET_APP="$2"; shift 2 ;;
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$TARGET_APP" ]; then
    echo "Error: --target-app is required"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    cat <<EOF
{
  "skill": "penetration-testing",
  "targetApp": "$TARGET_APP",
  "dryRun": true,
  "outputs": {
    "pentestPlan": "artifacts/reports/pentest-plan.md",
    "mitreMapping": "artifacts/reports/mitre-attack-plan.md",
    "wstgMapping": "artifacts/reports/owasp-wstg-mapping.md"
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    exit 0
fi

mkdir -p "$OUTPUT_DIR"
REPORT="$OUTPUT_DIR/pentest-plan.md"
cp "$TEMPLATES_DIR/pentest-plan.md" "$REPORT"
sed -i "s/\[Project Name\]/$TARGET_APP/g; s/\[Date\]/$(date)/g" "$REPORT"
echo "" >> "$REPORT"
echo "## MITRE ATT&CK Techniques" >> "$REPORT"
echo "" >> "$REPORT"
echo "- T1190: Exploit Public-Facing Application" >> "$REPORT"
echo "- T1078: Valid Accounts" >> "$REPORT"
echo "- T1505: Server Software Component" >> "$REPORT"
echo "" >> "$REPORT"
echo "## OWASP WSTG References" >> "$REPORT"
echo "" >> "$REPORT"
echo "- WSTG-INPV-01: SQL Injection Testing" >> "$REPORT"
echo "- WSTG-CRYP-01: Cryptographic Weakness Testing" >> "$REPORT"

echo "Created penetration testing plan for '$TARGET_APP' at $REPORT"
exit 0