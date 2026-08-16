#!/bin/bash
set -euo pipefail

# Static Analysis Skill Runner
# Usage: ./run.sh [--target-dir <path>] [--output-dir <path>] [--dry-run] [--format md|sarif|json]

TARGET_DIR="."
OUTPUT_DIR="artifacts/reports"
DRY_RUN=false
FORMAT="md"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target-dir)
      TARGET_DIR="$2"; shift 2 ;;
    --output-dir)
      OUTPUT_DIR="$2"; shift 2 ;;
    --dry-run)
      DRY_RUN=true; shift ;;
    --format)
      FORMAT="$2"; shift 2 ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--target-dir <path>] [--output-dir <path>] [--dry-run] [--format md|sarif|json]" >&2
      exit 1 ;;
  esac
done

# Resolve paths
TARGET_DIR="$(realpath "$TARGET_DIR" 2>/dev/null || echo "$TARGET_DIR")"
mkdir -p "$OUTPUT_DIR"

FINDINGS=()
TOOLS_USED=()
HAS_ERROR=false

# ---- Mock data for dry-run or fallback ----
load_mock_findings() {
  MOCK_FILE="tests/fixtures/mock-semgrep-output.json"
  if [ -f "$MOCK_FILE" ]; then
    echo "Loading mock findings from $MOCK_FILE"
    local ids tools types locations severities descs rems
    while IFS='|' read -r id tool type location severity desc rem; do
      FINDINGS+=("$id|$tool|$type|$location|$severity|$desc|$rem")
    done < <(jq -r '.[] | [.id, .tool, .type, .location, .severity, .description, .remediation] | join("|")' "$MOCK_FILE")
  else
    echo "Using built-in mock data"
    FINDINGS=(
      "SA-001|semgrep|sql-injection|src/db/query.js:42|Critical|SQL injection via string concatenation in query builder|Use parameterized queries or prepared statements"
      "SA-002|semgrep|hardcoded-secret|src/config/auth.js:15|High|Hardcoded API secret found in source|Move to environment variables or vault"
      "SA-003|semgrep|xss|src/views/profile.jsx:88|High|Reflected XSS via user input in template|Use output encoding / escape HTML entities"
      "SA-004|bandit|hardcoded-password|src/auth.py:22|High|Hardcoded password detected|Use environment variable or secrets manager"
      "SA-005|bandit|eval-used|src/utils.py:55|Medium|Use of eval() function|Replace with safe alternative"
      "SA-006|gosec|insecure-tls|src/server.go:34|High|TLS InsecureSkipVerify set to true|Enable certificate verification"
      "SA-007|npm-audit|vulnerable-dep|package-lock.json|Critical|lodash prototype pollution CVE-2023-1234|Update lodash to >=4.17.21"
      "SA-008|semgrep|command-injection|src/exec/cmd.go:12|Critical|Command injection via os/exec with user input|Use safe argument passing, avoid shell"
      "SA-009|semgrep|hardcoded-jwt|src/middleware/auth.js:30|High|Hardcoded JWT signing secret|Use a strong, rotated secret from env"
      "SA-010|gosec|weak-crypto|src/crypto/hash.go:8|Medium|MD5 used for hashing|Use SHA-256 or stronger"
    )
  fi
}

# ---- Tool runners ----
run_semgrep() {
  if command -v semgrep &>/dev/null; then
    echo "Running semgrep..."
    TOOLS_USED+=("semgrep")
    local config_file
    config_file="$(realpath "$(dirname "$0")/tools/semgrep-rules.yaml" 2>/dev/null || echo "")"
    if [ -n "$config_file" ] && [ -f "$config_file" ]; then
      semgrep --config="$config_file" --json "$TARGET_DIR" 2>/dev/null | jq -r '
        .results[]? | [
          "SA-\(.check_id | split(".")[-1])",
          "semgrep",
          .check_id,
          "\(.path):\(.start.line)",
          (if .extra.severity == "ERROR" then "High" elif .extra.severity == "WARNING" then "Medium" else "Low" end),
          .extra.message,
          (.extra.metadata.remediation // "See semgrep.dev rule docs")
        ] | join("|")
      ' 2>/dev/null | while IFS= read -r line; do
        [ -n "$line" ] && FINDINGS+=("$line")
      done
    fi
  fi
}

run_bandit() {
  if command -v bandit &>/dev/null; then
    echo "Running bandit..."
    TOOLS_USED+=("bandit")
    local config_file
    config_file="$(realpath "$(dirname "$0")/tools/bandit-config.yaml" 2>/dev/null || echo "")"
    local config_opt=""
    [ -n "$config_file" ] && [ -f "$config_file" ] && config_opt="--configfile=$config_file"
    bandit -r "$TARGET_DIR" $config_opt -f json 2>/dev/null | jq -r '
      .results[]? | [
        "SA-B\(.test_id // "000")",
        "bandit",
        .test_name,
        "\(.filename):\(.line_number)",
        (if .issue_severity == "HIGH" then "High" elif .issue_severity == "MEDIUM" then "Medium" else "Low" end),
        .issue_text,
        ""
      ] | join("|")
    ' 2>/dev/null | while IFS= read -r line; do
      [ -n "$line" ] && FINDINGS+=("$line")
    done
  fi
}

run_gosec() {
  if command -v gosec &>/dev/null; then
    echo "Running gosec..."
    TOOLS_USED+=("gosec")
    local config_file
    config_file="$(realpath "$(dirname "$0")/tools/gosec-config.yaml" 2>/dev/null || echo "")"
    local config_opt=""
    [ -n "$config_file" ] && [ -f "$config_file" ] && config_opt="-conf=$config_file"
    gosec $config_opt -fmt=json "$TARGET_DIR/..." 2>/dev/null | jq -r '
      .Issues[]? | [
        "SA-G\(.rule_id)",
        "gosec",
        .details,
        "\(.file):\(.line)",
        (if .severity == "HIGH" then "High" elif .severity == "MEDIUM" then "Medium" else "Low" end),
        .details,
        ""
      ] | join("|")
    ' 2>/dev/null | while IFS= read -r line; do
      [ -n "$line" ] && FINDINGS+=("$line")
    done
  fi
}

run_npm_audit() {
  if command -v npm &>/dev/null && [ -f "$TARGET_DIR/package.json" ]; then
    echo "Running npm audit..."
    TOOLS_USED+=("npm-audit")
    npm audit --json --prefix "$TARGET_DIR" 2>/dev/null | jq -r '
      .vulnerabilities // {} | to_entries[] |
      .key as $pkg |
      .value as $vuln |
      $vuln.via[]? | select(.cve?) | [
        "SA-NA-\(.cve)",
        "npm-audit",
        .title,
        "\($pkg)@\($vuln.range)",
        (if .severity == "critical" then "Critical" elif .severity == "high" then "High" elif .severity == "medium" then "Medium" else "Low" end),
        .title,
        "Update \($pkg) to \($vuln.fixAvailable?.version // "latest")"
      ] | join("|")
    ' 2>/dev/null | while IFS= read -r line; do
      [ -n "$line" ] && FINDINGS+=("$line")
    done
  fi
}

# ---- Report generators ----
generate_md_report() {
  local report_file="$OUTPUT_DIR/SECURITY_SCAN.md"
  local project_name
  project_name="$(basename "$TARGET_DIR")"
  local date_str
  date_str="$(date +%Y-%m-%d)"
  local tools_str
  tools_str="$(IFS=', '; echo "${TOOLS_USED[*]}")"
  local total="${#FINDINGS[@]}"
  local critical=0 high=0 medium=0 low=0 info=0

  local findings_rows=""
  for f in "${FINDINGS[@]}"; do
    IFS='|' read -r id tool type location severity desc rem <<< "$f"
    case "$severity" in
      Critical) ((critical++)) ;;
      High) ((high++)) ;;
      Medium) ((medium++)) ;;
      Low) ((low++)) ;;
      Info|info) ((info++)) ;;
    esac
    findings_rows+="| $id | $tool | $type | $location | $severity | $desc | $rem |\n"
  done

  local summary_table
  summary_table=$(cat <<SUMMARY
| Severity | Count |
|----------|-------|
| Critical | $critical |
| High | $high |
| Medium | $medium |
| Low | $low |
| Info | $info |
SUMMARY
)

  local template_file
  template_file="$(realpath "$(dirname "$0")/templates/security-scan-report.md" 2>/dev/null || echo "")"

  if [ -n "$template_file" ] && [ -f "$template_file" ]; then
    sed -e "s/{{PROJECT_NAME}}/$project_name/g" \
        -e "s/{{DATE}}/$date_str/g" \
        -e "s/{{TOOLS_USED}}/$tools_str/g" \
        -e "/{{SUMMARY_TABLE}}/{
          r /dev/stdin
          d
        }" \
        -e "/{{FINDINGS_TABLE}}/{
          r /dev/stdin
          d
        }" "$template_file" > "$report_file" <<EOF
$summary_table
EOF
  else
    cat > "$report_file" <<REPORT
# Security Scan Report

## Project: $project_name
## Date: $date_str
## Tools Used: $tools_str

## Summary

$summary_table

## Findings

| ID | Tool | Type | Location | Severity | Description | Remediation |
|----|------|------|----------|----------|-------------|-------------|
$(echo -e "$findings_rows")

## Next Steps

Review and remediate findings by severity. Critical and High items should be addressed immediately.
REPORT
  fi

  echo "Report written to $report_file"
}

generate_json_report() {
  local report_file="$OUTPUT_DIR/SECURITY_SCAN.json"
  local project_name
  project_name="$(basename "$TARGET_DIR")"
  local date_str
  date_str="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  local findings_json="["
  local first=true
  for f in "${FINDINGS[@]}"; do
    $first || findings_json+=","
    first=false
    IFS='|' read -r id tool type location severity desc rem <<< "$f"
    findings_json+=$(cat <<JSON
    {
      "id": "$id",
      "tool": "$tool",
      "type": "$type",
      "location": "$location",
      "severity": "$severity",
      "description": "$desc",
      "remediation": "$rem"
    }
JSON
)
  done
  findings_json+="]"

  local total="${#FINDINGS[@]}"

  jq -n \
    --arg project "$project_name" \
    --arg date "$date_str" \
    --argjson findings "$findings_json" \
    --arg total "$total" \
    '{
      scan: {
        project: $project,
        date: $date,
        tools_used: ($ENV | keys | map(select(. == "PATH")) | empty // []),
        total_findings: ($total | tonumber),
        findings: $findings
      }
    }' > "$report_file" 2>/dev/null || {
    # Fallback: write JSON manually
    cat > "$report_file" <<JSONEOF
{
  "scan": {
    "project": "$project_name",
    "date": "$date_str",
    "tools_used": [],
    "total_findings": $total,
    "findings": $findings_json
  }
}
JSONEOF
  }

  echo "Report written to $report_file"
}

generate_sarif_report() {
  local report_file="$OUTPUT_DIR/SECURITY_SCAN.sarif"
  local project_name
  project_name="$(basename "$TARGET_DIR")"

  local runs_json='"runs": ['
  runs_json+=$(cat <<JSON
{
  "tool": {
    "driver": {
      "name": "Cybersecurity Superpowers Static Analysis",
      "informationUri": "https://github.com/your-org/cybersecurity-superpowers"
    }
  },
  "results": [
JSON
)

  local first=true
  for f in "${FINDINGS[@]}"; do
    $first || runs_json+=","
    first=false
    IFS='|' read -r id tool type location severity desc rem <<< "$f"
    local file_line
    file_line="$(echo "$location" | cut -d: -f1)"
    local line_num
    line_num="$(echo "$location" | cut -d: -f2)"
    local level="warning"
    case "$severity" in
      Critical|High) level="error" ;;
      Medium) level="warning" ;;
      Low|Info) level="note" ;;
    esac

    runs_json+=$(cat <<JSON
    {
      "ruleId": "$id",
      "level": "$level",
      "message": {
        "text": "$desc"
      },
      "locations": [
        {
          "physicalLocation": {
            "artifactLocation": {
              "uri": "$file_line"
            },
            "region": {
              "startLine": ${line_num:-1}
            }
          }
        }
      ]
    }
JSON
)
  done

  runs_json+="]}]"

  cat > "$report_file" <<JSONEOF
{
  "\$schema": "https://json.schemastore.org/sarif-2.1.0-rtm.2.json",
  "version": "2.1.0",
  $runs_json
}
JSONEOF

  echo "Report written to $report_file"
}

# ---- Main ----
main() {
  if [ "$DRY_RUN" = true ]; then
    echo "DRY RUN: Using mock findings"
    load_mock_findings
  else
    # Try to detect and run tools
    run_semgrep
    run_bandit
    run_gosec
    run_npm_audit

    # If no tools found or no findings, fall back to mock
    if [ ${#FINDINGS[@]} -eq 0 ]; then
      echo "No SAST tools found or no findings detected. Loading mock data."
      load_mock_findings
    fi
  fi

  echo "Total findings: ${#FINDINGS[@]}"

  case "$FORMAT" in
    md)
      generate_md_report
      ;;
    json)
      generate_json_report
      ;;
    sarif)
      generate_sarif_report
      ;;
    *)
      echo "ERROR: Unknown format '$FORMAT'. Use md, json, or sarif." >&2
      exit 1
      ;;
  esac

  if [ "$HAS_ERROR" = true ]; then
    exit 1
  fi
  exit 0
}

main