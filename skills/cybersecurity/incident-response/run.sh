#!/usr/bin/env bash
# Incident Response skill - generate NIST 800-61 aligned playbook
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
REPORTS_DIR="$REPO_ROOT/artifacts/reports"
INCIDENT_TYPE=""
OUTPUT_FILE="$REPORTS_DIR/incident-response-report.md"

usage() {
  echo "Usage: $0 --type <incident-type>"
  echo "  --type   Incident type (e.g. ransomware, data-breach, DDoS) (required)"
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) INCIDENT_TYPE="$2"; shift 2 ;;
    --project) INCIDENT_TYPE="$2"; shift 2 ;;
    --help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

if [ -z "$INCIDENT_TYPE" ]; then
  echo "ERROR: --type is required"
  exit 1
fi

mkdir -p "$REPORTS_DIR"

echo "=== Incident Response: $INCIDENT_TYPE ==="
echo "Generating NIST 800-61 aligned playbook..."

cat > "$OUTPUT_FILE" << IREOF
# Incident Response Report: $INCIDENT_TYPE

**Generated:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Tool:** cybersecurity/incident-response

## NIST 800-61 Playbook: $INCIDENT_TYPE

### 1. Preparation
- Verify incident response team contact list
- Ensure forensic toolchain availability
- Activate communication channels

### 2. Detection & Analysis
| Indicator | Source | Severity |
|-----------|--------|----------|
| Suspicious file encryption events | EDR | Critical |
| Unusual outbound traffic | NDR | High |
| Ransom note creation | File integrity monitor | Critical |

### 3. Containment, Eradication & Recovery
- Isolate affected systems from network
- Identify patient-zero and scope
- Remove malware and restore from clean backups
- Verify no persistence mechanisms remain

### 4. Post-Incident Activity
- Conduct lessons-learned session
- Update threat catalog with IOCs
- Generate incident report for stakeholders
IREOF

echo "SUCCESS: Incident response report generated at $OUTPUT_FILE"