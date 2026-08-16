#!/bin/bash
# init-project.sh - Initialize project with security hooks, directory structure, and git config
# Creates all required directories, installs hook scripts into .git/hooks/,
# creates .gitkeep files, and verifies everything is ready to use.
# Usage: ./scripts/init-project.sh [--force]

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; }

HEADER() { echo -e "\n${CYAN}======== $1 ========${NC}"; }
SEPARATOR() { echo -e "${CYAN}----------------------------------------${NC}"; }

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$PROJECT_ROOT"

START_TIME=$(date +%s)
INIT_COUNT=0

HEADER "CyberSecurity Superpowers - Project Initialization"
echo ""

# ---- Directory structure ----
HEADER "Creating directory structure"
DIRECTORIES=(
  "tools"
  "docs/adr"
  "docs/architecture"
  "tests/skills"
  "tests/fixtures"
  "tests/security"
  "tests/integration"
  "artifacts/reports"
  "artifacts/sbom"
  "marketing"
  "assets"
)

for dir in "${DIRECTORIES[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    ok "Created: $dir"
    INIT_COUNT=$((INIT_COUNT + 1))
  else
    info "Exists: $dir"
  fi
done

# ---- .gitkeep files ----
HEADER "Creating .gitkeep files in empty directories"
find . -type d -empty ! -path './.git/*' ! -path '*/node_modules/*' ! -path '*/target/*' 2>/dev/null | while read -r d; do
  gitkeep_file="$d/.gitkeep"
  if [ ! -f "$gitkeep_file" ]; then
    touch "$gitkeep_file"
    ok "Created: $gitkeep_file"
    INIT_COUNT=$((INIT_COUNT + 1))
  fi
done

# ---- Git hooks ----
HEADER "Installing git hooks"
HOOKS_DIR="$(git rev-parse --git-dir 2>/dev/null)/hooks" || {
  fail "Not inside a git repository. Skipping hook installation."
  HOOKS_DIR=""
}

if [ -n "$HOOKS_DIR" ] && [ -d "$HOOKS_DIR" ]; then
  HOOK_TYPES=("pre-commit" "pre-push")
  INSTALLED_HOOKS=0

  for hook_type in "${HOOK_TYPES[@]}"; do
    hook_src_dir="hooks/$hook_type"
    if [ ! -d "$hook_src_dir" ]; then
      warn "Source directory not found: $hook_src_dir"
      continue
    fi

    for hook_src in "$hook_src_dir"/*.sh; do
      if [ ! -f "$hook_src" ]; then
        continue
      fi
      hook_name=$(basename "$hook_src" .sh)
      hook_dest="$HOOKS_DIR/$hook_name"

      cp "$hook_src" "$hook_dest"
      chmod +x "$hook_dest"
      ok "Installed hook: $hook_name -> $hook_dest"
      INSTALLED_HOOKS=$((INSTALLED_HOOKS + 1))
      INIT_COUNT=$((INIT_COUNT + 1))
    done
  done

  if [ "$INSTALLED_HOOKS" -gt 0 ]; then
    ok "$INSTALLED_HOOKS hook(s) installed successfully."
  else
    warn "No hooks were installed. Check hooks/ directory for *.sh files."
  fi
else
  warn "Git hooks directory not found. Skipping hook installation."
fi

# ---- Verify scripts are executable ----
HEADER "Verifying script permissions"
SCRIPT_DIRS=("hooks/pre-commit" "hooks/pre-push" "scripts")
for script_dir in "${SCRIPT_DIRS[@]}"; do
  if [ ! -d "$script_dir" ]; then
    warn "Directory not found: $script_dir"
    continue
  fi
  while IFS= read -r -d '' script; do
    if [ -x "$script" ]; then
      ok "Executable: $script"
    else
      chmod +x "$script"
      ok "Fixed permissions: $script"
      INIT_COUNT=$((INIT_COUNT + 1))
    fi
  done < <(find "$script_dir" -maxdepth 1 -name '*.sh' -print0 2>/dev/null || true)
done

# ---- .gitignore entry for generated scan reports ----
HEADER "Checking .gitignore for scan report exclusions"
GITIGNORE_FILE=".gitignore"
GITIGNORE_ENTRIES=(
  "# Generated scan reports"
  "secret-scan-report*"
  "gitleaks-report*"
  "semgrep-results*"
  "bandit-report*"
  "npm-audit-report*"
  "pip-audit-report*"
  "gosec-report*"
)

entries_needed=false
for entry in "${GITIGNORE_ENTRIES[@]}"; do
  if [ -f "$GITIGNORE_FILE" ] && grep -qF "$entry" "$GITIGNORE_FILE" 2>/dev/null; then
    continue
  fi
  entries_needed=true
  break
done

if [ "$entries_needed" = true ]; then
  echo "" >> "$GITIGNORE_FILE"
  for entry in "${GITIGNORE_ENTRIES[@]}"; do
    if [ -f "$GITIGNORE_FILE" ] && grep -qF "$entry" "$GITIGNORE_FILE" 2>/dev/null; then
      continue
    fi
    echo "$entry" >> "$GITIGNORE_FILE"
  done
  ok "Updated $GITIGNORE_FILE with scan report exclusions."
  INIT_COUNT=$((INIT_COUNT + 1))
else
  ok ".gitignore already has scan report exclusions."
fi

# ---- Completion summary ----
SEPARATOR
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

HEADER "Initialization Complete"
echo ""
echo -e "  ${CYAN}Duration:${NC}       ${DURATION}s"
echo -e "  ${CYAN}Actions taken:${NC}   $INIT_COUNT"
echo -e "  ${CYAN}Directory:${NC}       $PROJECT_ROOT"

echo ""
SEPARATOR
echo ""
echo -e "  ${GREEN}Pre-commit hooks:${NC}"
for hook in hooks/pre-commit/*.sh; do
  name=$(basename "$hook" .sh)
  echo "    - $name"
done

echo ""
echo -e "  ${GREEN}Pre-push hooks:${NC}"
for hook in hooks/pre-push/*.sh; do
  name=$(basename "$hook" .sh)
  echo "    - $name"
done

echo ""
echo -e "  ${GREEN}Directory structure:${NC}"
for dir in "${DIRECTORIES[@]}"; do
  echo "    - $dir/"
done

echo ""
SEPARATOR
info "Run './scripts/install-tools.sh' to install required tools."
info "Run 'git commit' to trigger pre-commit hooks."
info "Run 'git push' to trigger pre-push hooks."
echo ""

exit 0