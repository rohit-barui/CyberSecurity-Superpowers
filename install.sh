#!/usr/bin/env bash
# One-click installer for Cybersecurity Superpowers
# Usage: curl -sSL https://raw.githubusercontent.com/rohit-barui/CyberSecurity-Superpowers/main/install.sh | bash
set -euo pipefail

REPO="rohit-barui/CyberSecurity-Superpowers"
BRANCH="main"
INSTALL_DIR="${HOME}/.cybersec-superpowers"
BIN_DIR="${HOME}/.local/bin"
VERSION="0.1.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Cybersecurity Superpowers Installer v${VERSION}${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# ---- Prerequisites ----
echo "1. Checking prerequisites..."

OS="$(uname -s)"
case "$OS" in
  Linux|Darwin) ;;
  *)
    echo -e "${RED}Unsupported OS: $OS. Linux and macOS only.${NC}"
    exit 1
    ;;
esac

if ! command -v bash &>/dev/null; then
  echo -e "${RED}bash is required but not found.${NC}"
  exit 1
fi

BASH_VER=$(bash --version | head -1 | grep -oP '\d+\.\d+' | head -1 || echo "0")
if awk "BEGIN {exit !($BASH_VER < 4.0)}"; then
  echo -e "${RED}bash 4.0+ required (found $BASH_VER).${NC}"
  exit 1
fi

if ! command -v git &>/dev/null && ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
  echo -e "${RED}git, curl, or wget is required.${NC}"
  exit 1
fi

echo -e "  ${GREEN}✓${NC} OS: $OS"
echo -e "  ${GREEN}✓${NC} bash: $BASH_VER"
echo -e "  ${GREEN}✓${NC} $(command -v git &>/dev/null && echo 'git' || echo 'curl/wget') available"
echo ""

# ---- Download ----
echo "2. Downloading Cybersecurity Superpowers..."

DOWNLOAD_DIR=$(mktemp -d)
trap 'rm -rf "$DOWNLOAD_DIR"' EXIT

if command -v git &>/dev/null; then
  git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$DOWNLOAD_DIR" 2>/dev/null
elif command -v curl &>/dev/null; then
  curl -sSL "https://api.github.com/repos/$REPO/tarball/$BRANCH" | tar xz -C "$DOWNLOAD_DIR" --strip-components=1 2>/dev/null
elif command -v wget &>/dev/null; then
  wget -qO- "https://api.github.com/repos/$REPO/tarball/$BRANCH" | tar xz -C "$DOWNLOAD_DIR" --strip-components=1 2>/dev/null
fi

if [ ! -f "$DOWNLOAD_DIR/scripts/run-orchestrator.sh" ]; then
  echo -e "${RED}Download failed: scripts not found.${NC}"
  exit 1
fi

echo -e "  ${GREEN}✓${NC} Downloaded to $DOWNLOAD_DIR"
echo ""

# ---- Install ----
echo "3. Installing to $INSTALL_DIR..."

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR" "$BIN_DIR"

cp -r "$DOWNLOAD_DIR/skills" "$INSTALL_DIR/skills"
cp -r "$DOWNLOAD_DIR/scripts" "$INSTALL_DIR/scripts"
cp -r "$DOWNLOAD_DIR/tools" "$INSTALL_DIR/tools"
cp -r "$DOWNLOAD_DIR/hooks" "$INSTALL_DIR/hooks"
cp -r "$DOWNLOAD_DIR/tests" "$INSTALL_DIR/tests"
cp -r "$DOWNLOAD_DIR/examples" "$INSTALL_DIR/examples" 2>/dev/null || true
cp -r "$DOWNLOAD_DIR/artifacts" "$INSTALL_DIR/artifacts" 2>/dev/null || true
cp -r "$DOWNLOAD_DIR/docs" "$INSTALL_DIR/docs" 2>/dev/null || true
cp "$DOWNLOAD_DIR/VERSION" "$INSTALL_DIR/VERSION" 2>/dev/null || true
cp "$DOWNLOAD_DIR/README.md" "$INSTALL_DIR/README.md" 2>/dev/null || true

# Make all scripts executable
find "$INSTALL_DIR" -name "*.sh" -exec chmod +x {} \;

# Install the cybersec wrapper script
cat > "$BIN_DIR/cybersec" << 'WRAPPER'
#!/usr/bin/env bash
export CYBERSEC_ROOT="${HOME}/.cybersec-superpowers"
if [ ! -d "$CYBERSEC_ROOT" ]; then
  echo "Cybersecurity Superpowers not found at $CYBERSEC_ROOT"
  echo "Run: curl -sSL https://raw.githubusercontent.com/rohit-barui/CyberSecurity-Superpowers/main/install.sh | bash"
  exit 1
fi
cd "$CYBERSEC_ROOT"
case "${1:-}" in
  threat-model|implement|full)
    bash "$CYBERSEC_ROOT/scripts/run-orchestrator.sh" "$@"
    ;;
  demo)
    bash "$CYBERSEC_ROOT/examples/demo-project/run-demo.sh"
    ;;
  setup)
    bash "$CYBERSEC_ROOT/scripts/setup.sh"
    ;;
  suite)
    bash "$CYBERSEC_ROOT/scripts/run-security-suite.sh"
    ;;
  sbom)
    shift
    bash "$CYBERSEC_ROOT/scripts/generate-sbom.sh" "$@"
    ;;
  clear-eval)
    shift
    bash "$CYBERSEC_ROOT/scripts/run-clear-eval.sh" "$@"
    ;;
  init)
    bash "$CYBERSEC_ROOT/scripts/init-project.sh"
    ;;
  --help|-h|help|"")
    echo "Cybersecurity Superpowers v$(cat "$CYBERSEC_ROOT/VERSION" 2>/dev/null || echo '?')"
    echo ""
    echo "Usage: cybersec <command> [args]"
    echo ""
    echo "Commands:"
    echo "  threat-model <desc>   Run threat-modeling skill"
    echo "  implement <desc>      Run secure-coding + static-analysis"
    echo "  full <desc>           Run all 5 core skills"
    echo "  demo                  Run demo project"
    echo "  setup                 Check environment"
    echo "  suite                 Run full security suite"
    echo "  sbom [--target-dir]   Generate SBOM"
    echo "  clear-eval            Run CLEAR evaluation"
    echo "  init                  Install git hooks"
    echo ""
    echo "Examples:"
    echo "  cybersec threat-model 'MyApp'"
    echo "  cybersec full 'MyApp'"
    echo "  cybersec demo"
    ;;
  *)
    echo "Unknown command: ${1}"
    echo "Run 'cybersec --help' for usage."
    exit 1
    ;;
esac
WRAPPER
chmod +x "$BIN_DIR/cybersec"

echo -e "  ${GREEN}✓${NC} Scripts installed to $INSTALL_DIR"
echo -e "  ${GREEN}✓${NC} Wrapper installed to $BIN_DIR/cybersec"
echo ""

# ---- Update PATH ----
echo "4. Checking PATH..."
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  SHELL_PROFILE=""
  if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
  elif [ -n "${BASH_VERSION:-}" ]; then
    if [ -f "$HOME/.bash_profile" ]; then
      SHELL_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.bashrc" ]; then
      SHELL_PROFILE="$HOME/.bashrc"
    fi
  fi

  if [ -n "$SHELL_PROFILE" ]; then
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_PROFILE"
    echo -e "  ${YELLOW}⚠${NC} Added $BIN_DIR to PATH in $SHELL_PROFILE"
    echo -e "  ${YELLOW}⚠${NC} Run: source $SHELL_PROFILE"
  else
    echo -e "  ${YELLOW}⚠${NC} Add $BIN_DIR to your PATH manually:"
    echo -e "  ${YELLOW}⚠${NC}   export PATH=\"\$PATH:$BIN_DIR\""
  fi
else
  echo -e "  ${GREEN}✓${NC} $BIN_DIR already in PATH"
fi
echo ""

# ---- Summary ----
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  Quick start:"
echo "    cybersec --help"
echo "    cybersec demo"
echo "    cybersec threat-model 'My App'"
echo "    cybersec full 'My App'"
echo ""
echo "  Or via pip/pipx:"
echo "    pipx install cybersec-superpowers"
echo "    cybersec --help"
echo ""
echo "  Documentation:"
echo "    https://github.com/$REPO"
echo ""