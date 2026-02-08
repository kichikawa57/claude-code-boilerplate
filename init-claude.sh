#!/bin/bash
set -euo pipefail

# Claude Code Boilerplate - Setup Script
# Usage: ./init-claude.sh [target-directory]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"

echo "==================================="
echo "  Claude Code Boilerplate Setup"
echo "==================================="
echo ""
echo "Target directory: $TARGET_DIR"
echo ""

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  echo "Create it first: mkdir -p $TARGET_DIR"
  exit 1
fi

# Check if .claude already exists
if [ -d "$TARGET_DIR/.claude" ]; then
  read -p "⚠ .claude/ already exists. Overwrite? (y/N): " confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# Copy .claude directory
echo ">> Copying .claude/ directory..."
cp -r "$SCRIPT_DIR/.claude" "$TARGET_DIR/.claude"
echo "   Done."

# Copy CLAUDE.md if not exists
if [ ! -f "$TARGET_DIR/CLAUDE.md" ]; then
  echo ">> Copying CLAUDE.md..."
  cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  echo "   Done."
else
  echo ">> CLAUDE.md already exists, skipping."
fi

# Add entries to .gitignore
echo ">> Updating .gitignore..."
GITIGNORE_ENTRIES=(
  ".claude/settings.local.json"
  ".claude/CLAUDE.local.md"
  ".claude/agent-memory-local/"
)

if [ ! -f "$TARGET_DIR/.gitignore" ]; then
  touch "$TARGET_DIR/.gitignore"
fi

for entry in "${GITIGNORE_ENTRIES[@]}"; do
  if ! grep -qxF "$entry" "$TARGET_DIR/.gitignore" 2>/dev/null; then
    echo "$entry" >> "$TARGET_DIR/.gitignore"
  fi
done
echo "   Done."

# Detect package manager
echo ">> Detecting package manager..."
PM="none"
if [ -f "$TARGET_DIR/bun.lockb" ] || [ -f "$TARGET_DIR/bunfig.toml" ]; then
  PM="bun"
elif [ -f "$TARGET_DIR/pnpm-lock.yaml" ]; then
  PM="pnpm"
elif [ -f "$TARGET_DIR/yarn.lock" ]; then
  PM="yarn"
elif [ -f "$TARGET_DIR/package-lock.json" ] || [ -f "$TARGET_DIR/package.json" ]; then
  PM="npm"
elif [ -f "$TARGET_DIR/requirements.txt" ] || [ -f "$TARGET_DIR/pyproject.toml" ]; then
  PM="python"
elif [ -f "$TARGET_DIR/go.mod" ]; then
  PM="go"
elif [ -f "$TARGET_DIR/Cargo.toml" ]; then
  PM="rust"
fi
echo "   Detected: $PM"

# Create settings.local.json from example
echo ">> Creating settings.local.json..."
if [ -f "$TARGET_DIR/.claude/settings.local.json.example" ] && [ ! -f "$TARGET_DIR/.claude/settings.local.json" ]; then
  cp "$TARGET_DIR/.claude/settings.local.json.example" "$TARGET_DIR/.claude/settings.local.json"
  echo "   Done."
else
  echo "   Already exists or example not found, skipping."
fi

echo ""
echo "==================================="
echo "  Setup Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md with your project info"
echo "  2. Edit .claude/rules/ to match your coding standards"
echo "  3. Run 'claude' to start Claude Code"
echo ""
echo "Available commands:"
echo "  /overview     - Project overview"
echo "  /gen          - Generate code from patterns"
echo "  /add-test     - Add tests for a file"
echo "  /create-pr    - Create a pull request"
echo "  /check        - Run lint/typecheck/test"
echo "  /troubleshoot - Debug an error"
echo "  /doc          - Generate documentation"
echo ""
