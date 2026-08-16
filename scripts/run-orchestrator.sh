#!/usr/bin/env bash
# Orchestrator runner - routes task to appropriate cybersecurity skill(s)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../skills/cybersecurity"

usage() {
  cat <<EOF
Usage: $0 <mode> <description>

Modes:
  implement <desc>     Run secure-coding + static-analysis
  threat-model <desc>  Run threat-modeling
  full <desc>          Run all 5 skills sequentially

Options:
  --help               Show this help message

Examples:
  $0 implement "my-app"
  $0 threat-model "my-app"
  $0 full "my-app"
EOF
  exit 0
}

MODE="${1:-}"
DESCRIPTION="${2:-}"

[ "$MODE" = "--help" ] && usage

if [ -z "$MODE" ] || [ -z "$DESCRIPTION" ]; then
  echo "ERROR: Both mode and description are required."
  usage
fi

REPORTS=()

run_skill() {
  local skill="$1"
  local script="$SKILLS_DIR/$skill/run.sh"
  local flag="$2"
  echo ""
  echo "========================================"
  echo "  Running: $skill"
  echo "========================================"

  if [ ! -f "$script" ]; then
    echo "ERROR: Skill script not found: $script"
    exit 1
  fi

  if bash "$script" "$flag" "$DESCRIPTION"; then
    REPORTS+=("$skill: ✅ SUCCESS")
  else
    echo ""
    echo "ERROR: $skill failed. Aborting."
    exit 1
  fi
}

case "$MODE" in
  implement)
    run_skill "secure-coding" "--language" "auto"
    run_skill "static-analysis" "--target-dir" "$DESCRIPTION"
    ;;
  threat-model)
    run_skill "threat-modeling" "--project" "$DESCRIPTION"
    ;;
  full)
    run_skill "threat-modeling" "--project" "$DESCRIPTION"
    run_skill "secure-coding" "--language" "auto"
    run_skill "static-analysis" "--target-dir" "."
    run_skill "penetration-testing" "--target-app" "$DESCRIPTION"
    run_skill "incident-response" "--incident-type" "ransomware"
    ;;
  *)
    echo "ERROR: Unknown mode '$MODE'"
    usage
    ;;
esac

echo ""
echo "========================================"
echo "  Orchestration Complete - Summary"
echo "========================================"
for r in "${REPORTS[@]}"; do
  echo "  $r"
done
echo "========================================"
echo "Reports are in: artifacts/reports/"