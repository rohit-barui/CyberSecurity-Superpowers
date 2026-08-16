#!/usr/bin/env bash
# ==============================================================================
# Threat-Modeling Skill - run.sh
#
# Generates a STRIDE-based threat model with CVSS scoring for a given project.
# Usage: run.sh --project <name> [--output-dir <path>] [--dry-run] [--format md|json]
# ==============================================================================

set -euo pipefail

# --- Defaults ---
OUTPUT_DIR="artifacts/reports"
FORMAT="md"
DRY_RUN=false

# --- Script directory ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/templates/stride-model.md"

# --- Color helpers (optional) ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Parse flags ---
PROJECT_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --format)
      FORMAT="$2"
      shift 2
      ;;
    --help|-h)
      echo "Usage: $0 --project <name> [--output-dir <path>] [--dry-run] [--format md|json]"
      echo ""
      echo "Options:"
      echo "  --project <name>      (required) The project name for the threat model"
      echo "  --output-dir <path>   (default: artifacts/reports/) Output directory for generated files"
      echo "  --dry-run             Print JSON metadata to stdout instead of writing files"
      echo "  --format <md|json>    (default: md) Output format for the threat model"
      exit 0
      ;;
    *)
      echo -e "${RED}Error:${NC} Unknown option: $1"
      echo "Usage: $0 --project <name> [--output-dir <path>] [--dry-run] [--format md|json]"
      exit 1
      ;;
  esac
done

# --- Validate required flags ---
if [[ -z "$PROJECT_NAME" ]]; then
  echo -e "${RED}Error:${NC} --project is required"
  exit 1
fi

if [[ "$FORMAT" != "md" && "$FORMAT" != "json" ]]; then
  echo -e "${RED}Error:${NC} --format must be 'md' or 'json' (got: $FORMAT)"
  exit 1
fi

# --- Generate timestamp ---
TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# --- Build STRIDE table rows ---
# Each row: Category | Threat Description | Asset Affected | Impact | Likelihood | Risk Score | CVSS Vector | CVSS Score | Mitigation
#
# We generate placeholder/default rows that the user can customize.

STRIDE_TABLE=$(cat <<- 'ENDTABLE'
| Category | Threat Description | Asset Affected | Impact | Likelihood | Risk Score | CVSS Vector | CVSS Score | Mitigation |
|----------|-------------------|----------------|--------|------------|------------|-------------|------------|------------|
| Spoofing | Unauthorized actor impersonates a valid user or system component | Authentication tokens, user sessions | High | Medium | 7.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N | 9.1 | Implement multi-factor authentication; use certificate-based mutual TLS |
| Tampering | Attacker modifies data in transit or at rest | Database records, API payloads, log files | High | Medium | 7.0 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:N | 6.5 | Enable integrity checks (HMAC, digital signatures); use TLS 1.3; enforce audit logging |
| Repudiation | User denies performing an action without verifiable evidence | Transaction logs, audit trails | Medium | Low | 4.5 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N | 4.3 | Implement non-repudiation with digital signatures; enable immutable audit logs; use SIEM |
| Information Disclosure | Sensitive data exposed to unauthorized parties | PII database, API responses, config files | High | Medium | 7.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N | 7.5 | Encrypt data at rest (AES-256) and in transit (TLS 1.3); apply least privilege; mask PII in logs |
| Denial of Service | Attacker exhausts system resources to deny legitimate access | API endpoints, compute resources, network bandwidth | High | Medium | 6.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H | 7.5 | Rate limiting; auto-scaling groups; WAF with DDoS protection; circuit breakers |
| Elevation of Privilege | Attacker escalates from low-privileged to higher-privileged access | Role/ACL system, admin interfaces, kernel | Critical | Low | 8.0 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H | 8.8 | Apply principle of least privilege; regular RBAC audits; input validation; use seccomp/AppArmor |
ENDTABLE
)

# --- Build CVSS matrix section ---
CVSS_MATRIX=$(cat <<- 'ENDMATRIX'
### CVSS v3.1 Score Details

| Threat | AV | AC | PR | UI | S | C | I | A | Score | Severity |
|--------|----|----|----|----|----|----|----|----|-------|----------|
| Spoofing | N | L | N | N | U | H | H | N | 9.1 | Critical |
| Tampering | N | L | L | N | U | N | H | N | 6.5 | Medium |
| Repudiation | N | L | L | N | U | N | L | N | 4.3 | Medium |
| Information Disclosure | N | L | N | N | U | H | N | N | 7.5 | High |
| Denial of Service | N | L | N | N | U | N | N | H | 7.5 | High |
| Elevation of Privilege | N | L | L | N | U | H | H | H | 8.8 | High |
ENDMATRIX
)

# --- Dry-run: print JSON and exit ---
if [[ "$DRY_RUN" == true ]]; then
  cat <<- ENDJSON
{
  "tool": "threat-modeling",
  "project": "$PROJECT_NAME",
  "timestamp": "$TIMESTAMP",
  "format": "$FORMAT",
  "outputDir": "$OUTPUT_DIR",
  "outputFile": "${OUTPUT_DIR}/stride-model.md",
  "components": {
    "strideCategories": ["Spoofing", "Tampering", "Repudiation", "Information Disclosure", "Denial of Service", "Elevation of Privilege"],
    "threatCount": 6,
    "cvssMetrics": ["AV", "AC", "PR", "UI", "S", "C", "I", "A"],
    "highestRiskScore": 9.1,
    "severityDistribution": {
      "critical": 1,
      "high": 3,
      "medium": 2
    }
  },
  "mitigationSources": ["OWASP ASVS", "NIST SP 800-53", "CIS Benchmarks"],
  "status": "dry-run"
}
ENDJSON
  exit 0
fi

# --- Ensure template exists ---
if [[ ! -f "$TEMPLATE" ]]; then
  echo -e "${RED}Error:${NC} Template not found at $TEMPLATE"
  exit 1
fi

# --- Create output directory ---
mkdir -p "$OUTPUT_DIR"

# --- Read template and substitute tokens ---
if [[ "$FORMAT" == "md" ]]; then
  OUTPUT_FILE="${OUTPUT_DIR}/stride-model.md"

  sed -e "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
      -e "s/{{DATE}}/${TIMESTAMP}/g" \
      -e "s/{{CVSS_MATRIX}}/${CVSS_MATRIX}/g" \
      -e "s/{{STRIDE_TABLE}}/${STRIDE_TABLE}/g" \
      "$TEMPLATE" > "$OUTPUT_FILE"

  echo -e "${GREEN}✓${NC} Threat model written to ${OUTPUT_FILE}"
  exit 0

elif [[ "$FORMAT" == "json" ]]; then
  OUTPUT_FILE="${OUTPUT_DIR}/stride-model.json"

  # Generate JSON output
  cat > "$OUTPUT_FILE" <<- ENDJSON
{
  "tool": "threat-modeling",
  "project": "$PROJECT_NAME",
  "timestamp": "$TIMESTAMP",
  "format": "json",
  "threats": [
    {
      "category": "Spoofing",
      "description": "Unauthorized actor impersonates a valid user or system component",
      "asset": "Authentication tokens, user sessions",
      "impact": "High",
      "likelihood": "Medium",
      "riskScore": 7.5,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N",
      "cvssScore": 9.1,
      "severity": "Critical",
      "mitigation": "Implement multi-factor authentication; use certificate-based mutual TLS"
    },
    {
      "category": "Tampering",
      "description": "Attacker modifies data in transit or at rest",
      "asset": "Database records, API payloads, log files",
      "impact": "High",
      "likelihood": "Medium",
      "riskScore": 7.0,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:N",
      "cvssScore": 6.5,
      "severity": "Medium",
      "mitigation": "Enable integrity checks (HMAC, digital signatures); use TLS 1.3; enforce audit logging"
    },
    {
      "category": "Repudiation",
      "description": "User denies performing an action without verifiable evidence",
      "asset": "Transaction logs, audit trails",
      "impact": "Medium",
      "likelihood": "Low",
      "riskScore": 4.5,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N",
      "cvssScore": 4.3,
      "severity": "Medium",
      "mitigation": "Implement non-repudiation with digital signatures; enable immutable audit logs; use SIEM"
    },
    {
      "category": "Information Disclosure",
      "description": "Sensitive data exposed to unauthorized parties",
      "asset": "PII database, API responses, config files",
      "impact": "High",
      "likelihood": "Medium",
      "riskScore": 7.5,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N",
      "cvssScore": 7.5,
      "severity": "High",
      "mitigation": "Encrypt data at rest (AES-256) and in transit (TLS 1.3); apply least privilege; mask PII in logs"
    },
    {
      "category": "Denial of Service",
      "description": "Attacker exhausts system resources to deny legitimate access",
      "asset": "API endpoints, compute resources, network bandwidth",
      "impact": "High",
      "likelihood": "Medium",
      "riskScore": 6.5,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H",
      "cvssScore": 7.5,
      "severity": "High",
      "mitigation": "Rate limiting; auto-scaling groups; WAF with DDoS protection; circuit breakers"
    },
    {
      "category": "Elevation of Privilege",
      "description": "Attacker escalates from low-privileged to higher-privileged access",
      "asset": "Role/ACL system, admin interfaces, kernel",
      "impact": "Critical",
      "likelihood": "Low",
      "riskScore": 8.0,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H",
      "cvssScore": 8.8,
      "severity": "High",
      "mitigation": "Apply principle of least privilege; regular RBAC audits; input validation; use seccomp/AppArmor"
    }
  ],
  "mitigationSources": ["OWASP ASVS", "NIST SP 800-53", "CIS Benchmarks"],
  "status": "success"
}
ENDJSON

  echo -e "${GREEN}✓${NC} Threat model written to ${OUTPUT_FILE}"
  exit 0
fi