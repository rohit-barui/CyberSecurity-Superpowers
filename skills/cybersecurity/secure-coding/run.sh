#!/bin/bash
set -euo pipefail

# --- Defaults ---
LANGUAGE=""
TARGET_DIR="."
OUTPUT_DIR="artifacts/reports"
DRY_RUN=false

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --language)
      LANGUAGE="$2"
      shift 2
      ;;
    --target-dir)
      TARGET_DIR="$2"
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
    *)
      echo "Error: Unknown option $1" >&2
      exit 1
      ;;
  esac
done

# --- Auto-detect language if not provided ---
if [[ -z "$LANGUAGE" ]]; then
  JS_COUNT=$(find "$TARGET_DIR" -maxdepth 3 -name "*.js" -o -name "*.jsx" 2>/dev/null | wc -l)
  TS_COUNT=$(find "$TARGET_DIR" -maxdepth 3 -name "*.ts" -o -name "*.tsx" 2>/dev/null | wc -l)
  PY_COUNT=$(find "$TARGET_DIR" -maxdepth 3 -name "*.py" 2>/dev/null | wc -l)
  GO_COUNT=$(find "$TARGET_DIR" -maxdepth 3 -name "*.go" 2>/dev/null | wc -l)
  RS_COUNT=$(find "$TARGET_DIR" -maxdepth 3 -name "*.rs" 2>/dev/null | wc -l)

  if [[ "$TS_COUNT" -gt 0 ]]; then
    LANGUAGE="typescript"
  elif [[ "$JS_COUNT" -gt 0 ]]; then
    LANGUAGE="javascript"
  elif [[ "$PY_COUNT" -gt 0 ]]; then
    LANGUAGE="python"
  elif [[ "$GO_COUNT" -gt 0 ]]; then
    LANGUAGE="go"
  elif [[ "$RS_COUNT" -gt 0 ]]; then
    LANGUAGE="rust"
  fi
fi

# --- Validate language ---
VALID_LANGS=("javascript" "python" "typescript" "go" "rust")
LANG_FOUND=0
for vl in "${VALID_LANGS[@]}"; do
  if [[ "$vl" == "$LANGUAGE" ]]; then
    LANG_FOUND=1
    break
  fi
done

if [[ "$LANG_FOUND" -eq 0 ]]; then
  echo "Error: Could not detect language or unsupported language '$LANGUAGE'. Supported: javascript, python, typescript, go, rust" >&2
  exit 1
fi

# --- Paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKLIST_FILE="$SCRIPT_DIR/checklists/$LANGUAGE.md"
TEMPLATE_FILE="$SCRIPT_DIR/templates/security-checklist.md"
PROJECT_NAME="$(basename "$(cd "$TARGET_DIR" && pwd)")"
DATE="$(date +%Y-%m-%d)"

# --- Dry run ---
if $DRY_RUN; then
  CHECKLIST_ITEMS=$(grep '^- \[' "$CHECKLIST_FILE" 2>/dev/null || echo "")
  ITEM_COUNT=$(echo "$CHECKLIST_ITEMS" | grep -c '' || true)
  cat <<EOF
{
  "project": "$PROJECT_NAME",
  "language": "$LANGUAGE",
  "date": "$DATE",
  "target_dir": "$TARGET_DIR",
  "output_dir": "$OUTPUT_DIR",
  "checklist": "$CHECKLIST_FILE",
  "checklist_items": $ITEM_COUNT,
  "template": "$TEMPLATE_FILE",
  "output_file": "${OUTPUT_DIR}/SECURITY.md",
  "action": "Would generate SECURITY.md with $ITEM_COUNT checklist items"
}
EOF
  exit 0
fi

# --- Generate report ---
mkdir -p "$OUTPUT_DIR"

# Build checklist table rows
CHECKLIST_ROWS=""
IDX=1
while IFS= read -r line; do
  clean_line=$(echo "$line" | sed 's/^-\s*\[\s*\S?\s*\]\s*//')
  status=""
  if echo "$line" | grep -q '^- \[ \]'; then
    status="Not Checked"
  elif echo "$line" | grep -q '^- \[x\]'; then
    status="PASS"
  fi
  CHECKLIST_ROWS+="| $IDX | $clean_line | $status | |"$'\n'
  IDX=$((IDX + 1))
done < "$CHECKLIST_FILE"

# Build report
if [[ -f "$TEMPLATE_FILE" ]]; then
  REPORT=$(cat "$TEMPLATE_FILE")
  REPORT="${REPORT//"{{PROJECT_NAME}}"/$PROJECT_NAME}"
  REPORT="${REPORT//"{{LANGUAGE}}"/$LANGUAGE}"
  REPORT="${REPORT//"{{DATE}}"/$DATE}"
  REPORT="${REPORT//"{{CHECKLIST_ITEMS}}"/$CHECKLIST_ROWS}"
  REPORT="${REPORT//"{{VIOLATIONS}}"/| | | | |}"  # placeholder for empty violations
else
  # Fallback: build report from scratch
  REPORT="# Security Checklist - $PROJECT_NAME"$'\n\n'
  REPORT+="## Project: $PROJECT_NAME"$'\n'
  REPORT+="## Language: $LANGUAGE"$'\n'
  REPORT+="## Date: $DATE"$'\n\n'
  REPORT+="## Completed Checks"$'\n\n'
  REPORT+="| # | Check | Status | Notes |"$'\n'
  REPORT+="|---|-------|--------|-------|"$'\n'
  REPORT+="$CHECKLIST_ROWS"$'\n'
  REPORT+="## Violations Found"$'\n\n'
  REPORT+="| # | Issue | Location | Severity | Remediation |"$'\n'
  REPORT+="|---|-------|----------|----------|-------------|"$'\n'
  REPORT+="| | | | | |"$'\n\n'
  REPORT+="## Remediation Plan"$'\n\n'
  REPORT+="[Outline steps to fix each violation]"$'\n'
fi

echo "$REPORT" > "${OUTPUT_DIR}/SECURITY.md"
echo "Generated security checklist at ${OUTPUT_DIR}/SECURITY.md"
exit 0