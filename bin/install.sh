#!/bin/bash
# Dupla-Workflow v2 Installation Script
# Deploys to Claude Code (.claude/) and Antigravity (.agent/) IDEs
# Usage: bash bin/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENT_DIR="$HOME/.agent"
SKILLS_SOURCE="$SCRIPT_DIR/skills"
TEMPLATES_SOURCE="$SCRIPT_DIR/templates"
GLOBAL_TEMPLATES_SOURCE="$SCRIPT_DIR/global-templates"

echo "🚀 Dupla-Workflow v2 Installation"
echo "=================================="

# Detect IDEs
HAS_CLAUDE=false
HAS_ANTIGRAVITY=false

[ -d "$CLAUDE_DIR" ] && HAS_CLAUDE=true
[ -d "$AGENT_DIR" ] && HAS_ANTIGRAVITY=true

if [ "$HAS_CLAUDE" = false ] && [ "$HAS_ANTIGRAVITY" = false ]; then
  echo "❌ Neither Claude Code nor Antigravity detected."
  echo "   Install Claude Code CLI or Antigravity first."
  exit 1
fi

# Create directories if needed
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/templates"
[ "$HAS_ANTIGRAVITY" = true ] && mkdir -p "$AGENT_DIR/skills"

# Deploy skills
echo "📦 Deploying skills..."
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/skills/" 2>/dev/null || true
[ "$HAS_ANTIGRAVITY" = true ] && cp "$SKILLS_SOURCE"/*.md "$AGENT_DIR/skills/" 2>/dev/null || true
echo "   ✓ Skills deployed to ~/.claude/skills/"
[ "$HAS_ANTIGRAVITY" = true ] && echo "   ✓ Skills deployed to ~/.agent/skills/"

# Deploy templates reference (for projects)
echo "📋 Setting up templates directory structure..."
mkdir -p "$CLAUDE_DIR/templates"
echo "Templates are located in: $TEMPLATES_SOURCE" > "$CLAUDE_DIR/templates/README.md"
echo "   ✓ Templates reference created"

# Create .claudeignore
echo "🔒 Creating .claudeignore..."
cat > "$SCRIPT_DIR/.claudeignore" << 'EOF'
node_modules/
.next/
dist/
build/
*.log
.env*
coverage/
.git/
skills-backup/
EOF
echo "   ✓ .claudeignore created"

# Check if Antigravity needs CLAUDE.md
if [ "$HAS_ANTIGRAVITY" = true ]; then
  if [ ! -f "$AGENT_DIR/CLAUDE.md" ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "📌 Syncing CLAUDE.md to Antigravity..."
    cp "$CLAUDE_DIR/CLAUDE.md" "$AGENT_DIR/CLAUDE.md"
    echo "   ✓ CLAUDE.md synced to ~/.agent/"
  fi
fi

# Create dupla version marker
echo "$(cat "$SCRIPT_DIR/VERSION")" > "$CLAUDE_DIR/DUPLA_VERSION"
[ "$HAS_ANTIGRAVITY" = true ] && cp "$CLAUDE_DIR/DUPLA_VERSION" "$AGENT_DIR/DUPLA_VERSION"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Run: /setup-dupla"
echo "  2. Or if migrating: /adapt-project"
echo ""
echo "IDEs configured:"
[ "$HAS_CLAUDE" = true ] && echo "  ✓ Claude Code (~/.claude/skills/)"
[ "$HAS_ANTIGRAVITY" = true ] && echo "  ✓ Antigravity (~/.agent/skills/)"
echo ""
