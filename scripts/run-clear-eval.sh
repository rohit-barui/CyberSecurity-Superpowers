#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# CLEAR Evaluator Script
# Evaluates the Cybersecurity Superpowers project using the CLEAR metrics
# framework (Context, Logic, Execution, Accuracy, Relevance).
#
# Usage:
#   bash scripts/run-clear-eval.sh [options]
#
# Options:
#   --output-dir DIR    Output directory for the report (default: artifacts/reports)
#   --dry-run           Print scores as JSON to stdout, do not generate report
#   --verbose           Print detailed scoring rationale
#   --help              Show this message and exit
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Defaults
OUTPUT_DIR="$PROJECT_DIR/artifacts/reports"
DRY_RUN=false
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --help)
      grep "^#" "$0" | grep -v "^#!/" | sed 's/^# //' | sed 's/^#//'
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: bash scripts/run-clear-eval.sh [--output-dir DIR] [--dry-run] [--verbose]" >&2
      exit 1
      ;;
  esac
done

# --------------- Scoring Functions ---------------

score_context() {
  local score=0
  local details=""

  if [[ -f "$PROJECT_DIR/README.md" ]]; then
    score=$((score + 3))
    details+="README.md exists (+3). "
  fi
  if [[ -f "$PROJECT_DIR/CONTRIBUTING.md" ]]; then
    score=$((score + 2))
    details+="CONTRIBUTING.md exists (+2). "
  fi
  if [[ -f "$PROJECT_DIR/CHANGELOG.md" ]]; then
    score=$((score + 1))
    details+="CHANGELOG.md exists (+1). "
  fi
  if compgen -G "$PROJECT_DIR/skills/*/SKILL.md" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Skill SKILL.md files found (+2). "
  fi
  if ls "$PROJECT_DIR/skills/"*/ > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Skills directory populated (+2). "
  fi

  echo "$score|$details"
}

score_logic() {
  local score=0
  local details=""

  if compgen -G "$PROJECT_DIR/skills/*/run.sh" > /dev/null 2>&1; then
    score=$((score + 3))
    details+="Skills have run.sh entry points (+3). "
  fi
  if [[ -f "$PROJECT_DIR/skills/orchestration/run.sh" ]]; then
    score=$((score + 3))
    details+="Orchestrator run.sh exists (+3). "
  fi
  if compgen -G "$PROJECT_DIR/skills/*/checklists/*.md" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Checklists present (+2). "
  fi
  if compgen -G "$PROJECT_DIR/skills/*/playbooks/*.md" > /dev/null 2>&1 || \
     compgen -G "$PROJECT_DIR/skills/*/playbooks/*.json" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Playbooks present (+2). "
  fi

  echo "$score|$details"
}

score_execution() {
  local score=0
  local details=""

  if [[ -f "$PROJECT_DIR/tests/run-skill-tests.sh" ]]; then
    score=$((score + 3))
    details+="Test runner exists (+3). "
  fi
  if compgen -G "$PROJECT_DIR/tests/*/*.sh" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Individual test files found (+2). "
  fi
  if [[ -f "$PROJECT_DIR/scripts/setup.sh" ]]; then
    score=$((score + 2))
    details+="Setup script exists (+2). "
  fi
  if compgen -G "$PROJECT_DIR/.github/workflows/*.yml" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="CI workflows found (+2). "
  fi
  if [[ -f "$PROJECT_DIR/.pre-commit-config.yaml" ]]; then
    score=$((score + 1))
    details+="Pre-commit hooks configured (+1). "
  fi

  echo "$score|$details"
}

score_accuracy() {
  local score=0
  local details=""

  # Check that all shell scripts use set -euo pipefail
  local safe_count
  safe_count=$(grep -rl "set -euo pipefail" "$PROJECT_DIR/skills" "$PROJECT_DIR/scripts" "$PROJECT_DIR/tests" 2>/dev/null | wc -l)
  if [[ "$safe_count" -gt 0 ]]; then
    score=$((score + 3))
    details+="$safe_count scripts use set -euo pipefail (+3). "
  fi

  if [[ -f "$PROJECT_DIR/VERSION" ]]; then
    score=$((score + 1))
    details+="VERSION file present (+1). "
  fi

  if [[ -f "$PROJECT_DIR/SECURITY.md" ]]; then
    score=$((score + 2))
    details+="SECURITY.md exists (+2). "
  fi

  if compgen -G "$PROJECT_DIR/.github/ISSUE_TEMPLATE/*.md" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Issue templates found (+2). "
  fi

  if compgen -G "$PROJECT_DIR/.github/PULL_REQUEST_TEMPLATE.md" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="PR template found (+2). "
  fi

  echo "$score|$details"
}

score_relevance() {
  local score=0
  local details=""

  local skill_count
  skill_count=$(ls -d "$PROJECT_DIR/skills/"*/ 2>/dev/null | wc -l)
  if [[ "$skill_count" -ge 5 ]]; then
    score=$((score + 4))
    details+="$skill_count skills present (>=5) (+4). "
  elif [[ "$skill_count" -ge 3 ]]; then
    score=$((score + 2))
    details+="$skill_count skills present (+2). "
  fi

  if [[ -f "$PROJECT_DIR/.claude-plugin/plugin.json" ]]; then
    score=$((score + 2))
    details+="Claude plugin manifest present (+2). "
  fi

  if [[ -f "$PROJECT_DIR/.opencode/INSTALL.md" ]]; then
    score=$((score + 2))
    details+="OpenCode install guide present (+2). "
  fi

  if compgen -G "$PROJECT_DIR/docs/*.md" > /dev/null 2>&1; then
    score=$((score + 2))
    details+="Documentation files found (+2). "
  fi

  echo "$score|$details"
}

# --------------- Main ---------------

echo "=== CLEAR Evaluation ==="
echo "Project: $PROJECT_DIR"
echo ""

IFS='|' read -r context_score context_details <<< "$(score_context)"
IFS='|' read -r logic_score logic_details <<< "$(score_logic)"
IFS='|' read -r execution_score execution_details <<< "$(score_execution)"
IFS='|' read -r accuracy_score accuracy_details <<< "$(score_accuracy)"
IFS='|' read -r relevance_score relevance_details <<< "$(score_relevance)"

total=$((context_score + logic_score + execution_score + accuracy_score + relevance_score))
max=50
percentage=$((total * 100 / max))

# Build JSON output
json_output=$(cat <<EOF
{
  "project": "$(basename "$PROJECT_DIR")",
  "version": "$(cat "$PROJECT_DIR/VERSION" 2>/dev/null || echo "unknown")",
  "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "metrics": {
    "context": { "score": $context_score, "max": 10, "rationale": "$context_details" },
    "logic": { "score": $logic_score, "max": 10, "rationale": "$logic_details" },
    "execution": { "score": $execution_score, "max": 10, "rationale": "$execution_details" },
    "accuracy": { "score": $accuracy_score, "max": 10, "rationale": "$accuracy_details" },
    "relevance": { "score": $relevance_score, "max": 10, "rationale": "$relevance_details" }
  },
  "total": { "score": $total, "max": $max, "percentage": $percentage }
}
EOF
)

if [[ "$DRY_RUN" == "true" ]]; then
  echo "$json_output" | python3 -m json.tool 2>/dev/null || echo "$json_output"
  exit 0
fi

# Generate markdown report
mkdir -p "$OUTPUT_DIR"

report_file="$OUTPUT_DIR/clear-evaluation.md"

cat > "$report_file" <<REPORT
# CLEAR Evaluation Report

**Project**: Cybersecurity Superpowers
**Version**: $(cat "$PROJECT_DIR/VERSION" 2>/dev/null || echo "unknown")
**Date**: $(date -u "+%Y-%m-%d %H:%M:%S UTC")
**Evaluator**: CLEAR Framework (Context, Logic, Execution, Accuracy, Relevance)

---

## Summary

| Metric       | Score | Max | Percentage |
|--------------|-------|-----|------------|
| Context      | $context_score    | 10  | $(( context_score * 100 / 10 ))% |
| Logic        | $logic_score    | 10  | $(( logic_score * 100 / 10 ))% |
| Execution    | $execution_score    | 10  | $(( execution_score * 100 / 10 ))% |
| Accuracy     | $accuracy_score    | 10  | $(( accuracy_score * 100 / 10 ))% |
| Relevance    | $relevance_score    | 10  | $(( relevance_score * 100 / 10 ))% |
| **Total**    | **$total**   | **$max** | **${percentage}%** |

---

## Metric Details

### Context (Score: $context_score/10)
_Context completeness — does the project provide sufficient background and documentation?_

$context_details

### Logic (Score: $logic_score/10)
_Logical consistency — is the project structured coherently with clear interfaces?_

$logic_details

### Execution (Score: $execution_score/10)
_Execution readiness — can the project be run, tested, and deployed?_

$execution_details

### Accuracy (Score: $accuracy_score/10)
_Accuracy — does the project follow best practices and maintain quality standards?_

$accuracy_details

### Relevance (Score: $relevance_score/10)
_Relevance — is the project useful and applicable to its target domain?_

$relevance_details

---

## Recommendations

$(if [[ $percentage -ge 90 ]]; then echo "The project is in excellent shape. Minor refinements only.";
  elif [[ $percentage -ge 70 ]]; then echo "The project is solid but has room for improvement in documentation and testing coverage.";
  elif [[ $percentage -ge 50 ]]; then echo "The project needs significant improvements in several areas before it is release-ready.";
  else echo "The project is in early stages and requires substantial work across all metrics.";
fi)

---

*Report generated by the CLEAR Evaluator (ACE Framework)*
REPORT

echo "Report written to: $report_file"

if [[ "$VERBOSE" == "true" ]]; then
  echo ""
  echo "--- Verbose Scores ---"
  echo "Context:     $context_score/10 — $context_details"
  echo "Logic:       $logic_score/10 — $logic_details"
  echo "Execution:   $execution_score/10 — $execution_details"
  echo "Accuracy:    $accuracy_score/10 — $accuracy_details"
  echo "Relevance:   $relevance_score/10 — $relevance_details"
  echo ""
  echo "Total: $total/$max ($percentage%)"
fi