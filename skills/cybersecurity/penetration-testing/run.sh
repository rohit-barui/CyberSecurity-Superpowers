#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# TASK-04: Penetration-Testing Skill - Plan Generator
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$SCRIPT_DIR"
TEMPLATES_DIR="$SKILL_ROOT/templates"

TARGET_APP=""
SCOPE="web"
OUTPUT_DIR="artifacts/reports"
DRY_RUN=false

usage() {
    cat <<EOF
Usage: $(basename "$0") --target-app <name> [--scope <range>] [--output-dir <path>] [--dry-run]

Options:
  --target-app <name>      Target application name (required)
  --scope <range>          Scope of test (default: "web")
  --output-dir <path>      Output directory for plan (default: "artifacts/reports")
  --dry-run                Print plan metadata as JSON to stdout only
  --help                   Show this help message
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target-app)
            TARGET_APP="$2"; shift 2 ;;
        --scope)
            SCOPE="$2"; shift 2 ;;
        --output-dir)
            OUTPUT_DIR="$2"; shift 2 ;;
        --dry-run)
            DRY_RUN=true; shift ;;
        --help)
            usage ;;
        *)
            echo "ERROR: Unknown option: $1" >&2
            usage >&2
            exit 1 ;;
    esac
done

if [[ -z "$TARGET_APP" ]]; then
    echo "ERROR: --target-app is required" >&2
    usage >&2
    exit 1
fi

if [[ ! -d "$TEMPLATES_DIR" ]]; then
    echo "ERROR: Templates directory not found: $TEMPLATES_DIR" >&2
    exit 1
fi

# ---- Attack vector to framework mappings ----
declare -A OWASP_MAP
OWASP_MAP["sqli"]="WSTG-INPV-05"
OWASP_MAP["xss"]="WSTG-INPV-01"
OWASP_MAP["xss_stored"]="WSTG-INPV-02"
OWASP_MAP["cmd_injection"]="WSTG-INPV-09"
OWASP_MAP["idor"]="WSTG-ATHZ-01"
OWASP_MAP["broken_auth"]="WSTG-ATHN-01"
OWASP_MAP["session_hijack"]="WSTG-SESS-01"
OWASP_MAP["ssrf"]="WSTG-INPV-11"
OWASP_MAP["file_upload"]="WSTG-INPV-10"
OWASP_MAP["info_disclosure"]="WSTG-INFO-01"
OWASP_MAP["misconfig"]="WSTG-CONF-01"
OWASP_MAP["api_abuse"]="WSTG-APIT-01"

declare -A MITRE_MAP
MITRE_MAP["sqli"]="TA0001:T1190"
MITRE_MAP["xss"]="TA0001:T1189"
MITRE_MAP["xss_stored"]="TA0001:T1189"
MITRE_MAP["cmd_injection"]="TA0002:T1059"
MITRE_MAP["idor"]="TA0004:T1546"
MITRE_MAP["broken_auth"]="TA0006:T1078"
MITRE_MAP["session_hijack"]="TA0006:T1539"
MITRE_MAP["ssrf"]="TA0001:T1190"
MITRE_MAP["file_upload"]="TA0003:T1505"
MITRE_MAP["info_disclosure"]="TA0007:T1082"
MITRE_MAP["misconfig"]="TA0005:T1562"
MITRE_MAP["api_abuse"]="TA0001:T1190"

# --- Scope-based attack vector selection ---
get_vectors_for_scope() {
    local scope="$1"
    case "$scope" in
        web)
            echo "sqli xss xss_stored cmd_injection idor broken_auth session_hijack misconfig info_disclosure"
            ;;
        api)
            echo "sqli cmd_injection idor broken_auth api_abuse ssrf misconfig"
            ;;
        full)
            echo "sqli xss xss_stored cmd_injection idor broken_auth session_hijack ssrf file_upload info_disclosure misconfig api_abuse"
            ;;
        *)
            echo "sqli xss cmd_injection idor broken_auth misconfig"
            ;;
    esac
}

# --- Generate test cases table rows ---
generate_test_cases() {
    local vectors=($1)
    local rows=""
    local i=1
    for vec in "${vectors[@]}"; do
        local owasp="${OWASP_MAP[$vec]}"
        local mitre="${MITRE_MAP[$vec]}"
        local mitre_tactic="${mitre%%:*}"
        local mitre_tech="${mitre##*:}"
        local desc=""
        case "$vec" in
            sqli) desc="SQL Injection on input fields and API parameters" ;;
            xss) desc="Reflected Cross-Site Scripting (XSS)" ;;
            xss_stored) desc="Stored Cross-Site Scripting (XSS)" ;;
            cmd_injection) desc="Command Injection in user-supplied inputs" ;;
            idor) desc="Insecure Direct Object Reference testing" ;;
            broken_auth) desc="Authentication bypass attempts" ;;
            session_hijack) desc="Session token interception and replay" ;;
            ssrf) desc="Server-Side Request Forgery tests" ;;
            file_upload) desc="Malicious file upload validation" ;;
            info_disclosure) desc="Information disclosure through error messages" ;;
            misconfig) desc="Security misconfiguration scanning" ;;
            api_abuse) desc="API endpoint abuse and parameter tampering" ;;
            *) desc="Security assessment for $vec" ;;
        esac
        rows+="| TC-$(printf '%02d' $i) | $desc | $mitre_tactic / $mitre_tech | $owasp | See detailed steps in appendices | No critical findings | Burp Suite, sqlmap, nmap, custom scripts |"
        rows+=$'\n'
        ((i++))
    done
    echo "$rows"
}

# --- Dry-run output ---
if $DRY_RUN; then
    VECTORS=$(get_vectors_for_scope "$SCOPE")
    TEST_ROWS=$(generate_test_cases "$VECTORS")
    DATE=$(date +%Y-%m-%d)
    cat <<EOF
{
  "skill": "penetration-testing",
  "target_app": "$TARGET_APP",
  "scope": "$SCOPE",
  "output_dir": "$OUTPUT_DIR",
  "date": "$DATE",
  "attack_vectors": [$(for v in $VECTORS; do echo -n "\"$v\","; done | sed 's/,$//')],
  "total_test_cases": $(echo "$VECTORS" | wc -w),
  "frameworks": {
    "owasp_wstg": true,
    "mitre_attack": true,
    "ptes": true
  },
  "output_file": "${OUTPUT_DIR}/pentest-plan.md",
  "template": "${TEMPLATES_DIR}/pentest-plan.md"
}
EOF
    exit 0
fi

# --- Generate the plan ---
VECTORS=$(get_vectors_for_scope "$SCOPE")
TEST_CASES=$(generate_test_cases "$VECTORS")
DATE=$(date +%Y-%m-%d)
TIMELINE="7 business days (14 calendar days)"

TEMPLATE_FILE="$TEMPLATES_DIR/pentest-plan.md"
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "ERROR: Template not found: $TEMPLATE_FILE" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/pentest-plan.md"

sed -e "s/{{TARGET_APP}}/$TARGET_APP/g" \
    -e "s/{{SCOPE}}/$SCOPE/g" \
    -e "s/{{DATE}}/$DATE/g" \
    -e "s/{{TEST_CASES}}/$TEST_CASES/g" \
    -e "s/{{TIMELINE}}/$TIMELINE/g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "SUCCESS: Pentest plan written to $OUTPUT_FILE"
exit 0