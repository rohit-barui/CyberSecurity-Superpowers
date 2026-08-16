#!/usr/bin/env bash
# Incident Response Skill - run.sh
# Generates a NIST-aligned incident response playbook
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../../../superpowers/skills/cybersecurity/incident-response/templates" && pwd)"

INCIDENT_TYPE=""
OUTPUT_DIR="."
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --incident-type) INCIDENT_TYPE="$2"; shift 2 ;;
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$INCIDENT_TYPE" ]; then
    echo "Error: --incident-type is required"
    exit 1
fi

# Validate incident type
VALID_TYPES=("ransomware" "data-breach" "ddos" "phishing" "insider-threat" "malware" "unauthorized-access")
VALID=false
for vt in "${VALID_TYPES[@]}"; do
    if [ "$vt" = "$INCIDENT_TYPE" ]; then
        VALID=true
        break
    fi
done

if [ "$VALID" = false ]; then
    echo "Error: Invalid incident type '$INCIDENT_TYPE'. Valid types: ${VALID_TYPES[*]}"
    exit 2
fi

if [ "$DRY_RUN" = true ]; then
    cat <<EOF
{
  "skill": "incident-response",
  "incidentType": "$INCIDENT_TYPE",
  "dryRun": true,
  "outputs": {
    "playbook": "artifacts/reports/incident-playbook.md",
    "communicationTemplate": "artifacts/reports/communication-template.md",
    "lessonsLearned": "artifacts/reports/lessons-learned.md"
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    exit 0
fi

mkdir -p "$OUTPUT_DIR"
REPORT="$OUTPUT_DIR/incident-playbook.md"
cp "$TEMPLATES_DIR/incident-playbook.md" "$REPORT"
sed -i "s/\[Type\]/$INCIDENT_TYPE/g; s/\[Critical\/High\/Medium\/Low\]/Critical/g" "$REPORT"

echo "Created incident response playbook for '$INCIDENT_TYPE' at $REPORT"
exit 0