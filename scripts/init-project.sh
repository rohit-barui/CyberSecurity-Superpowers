#!/bin/bash
# Initialize project with security hooks and directory structure

set -euo pipefail

echo "Initializing CyberSecurity Superpowers..."

# Create required directories
mkdir -p docs/adr docs/architecture tests/skills tests/integration tests/security artifacts/reports artifacts/sbom scripts hooks/pre-commit hooks/pre-push

# Set up git hooks
HOOKS_DIR="$(git rev-parse --git-dir)/hooks"
if [ -d "$HOOKS_DIR" ]; then
  echo "Installing pre-commit hooks..."
  for hook in hooks/pre-commit/*.sh; do
    hook_name=$(basename "$hook" .sh)
    cp "$hook" "$HOOKS_DIR/$hook_name"
    chmod +x "$HOOKS_DIR/$hook_name"
  done

  echo "Installing pre-push hooks..."
  for hook in hooks/pre-push/*.sh; do
    hook_name=$(basename "$hook" .sh)
    cp "$hook" "$HOOKS_DIR/$hook_name"
    chmod +x "$HOOKS_DIR/$hook_name"
  done

  echo "Git hooks installed."
fi

echo "Initialization complete."