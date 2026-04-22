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

# Antigravity detection — check Unix path AND Windows paths (Git Bash)
[ -d "$AGENT_DIR" ] && HAS_ANTIGRAVITY=true

# Windows fallback: USERPROFILE/.agent (Git Bash maps ~ to USERPROFILE)
if [ "$HAS_ANTIGRAVITY" = false ] && [ -n "$USERPROFILE" ]; then
  WIN_AGENT_DIR=$(echo "$USERPROFILE" | sed 's|\\|/|g')"/.agent"
  [ -d "$WIN_AGENT_DIR" ] && AGENT_DIR="$WIN_AGENT_DIR" && HAS_ANTIGRAVITY=true
fi

# AppData fallback (some Antigravity versions on Windows)
if [ "$HAS_ANTIGRAVITY" = false ] && [ -n "$APPDATA" ]; then
  APPDATA_AGENT=$(echo "$APPDATA" | sed 's|\\|/|g')"/Antigravity"
  [ -d "$APPDATA_AGENT" ] && AGENT_DIR="$APPDATA_AGENT" && HAS_ANTIGRAVITY=true
fi

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
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/skills/" 2>/dev/null || true
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true
[ "$HAS_ANTIGRAVITY" = true ] && cp "$SKILLS_SOURCE"/*.md "$AGENT_DIR/skills/" 2>/dev/null || true
echo "   ✓ Skills deployed to ~/.claude/skills/ (Antigravity)"
echo "   ✓ Skills deployed to ~/.claude/commands/ (Claude Code slash commands)"
[ "$HAS_ANTIGRAVITY" = true ] && echo "   ✓ Skills deployed to ~/.agent/skills/"

# Deploy templates reference (for projects)
echo "📋 Setting up templates directory structure..."
mkdir -p "$CLAUDE_DIR/templates"
echo "Templates are located in: $TEMPLATES_SOURCE" > "$CLAUDE_DIR/templates/README.md"
echo "   ✓ Templates reference created"

# Create .claudeignore (only if it doesn't exist — never overwrite user's file)
if [ ! -f "$SCRIPT_DIR/.claudeignore" ]; then
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
else
  echo "   ✓ .claudeignore already exists — skipped"
fi

# Check if Antigravity needs CLAUDE.md
if [ "$HAS_ANTIGRAVITY" = true ]; then
  if [ ! -f "$AGENT_DIR/CLAUDE.md" ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "📌 Syncing CLAUDE.md to Antigravity..."
    cp "$CLAUDE_DIR/CLAUDE.md" "$AGENT_DIR/CLAUDE.md"
    echo "   ✓ CLAUDE.md synced to ~/.agent/"
  fi
fi

# Deploy hooks
echo "🔧 Deploying hooks..."
mkdir -p "$CLAUDE_DIR/hooks"
cp "$SCRIPT_DIR/hooks"/*.sh "$CLAUDE_DIR/hooks/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/hooks"/*.sh 2>/dev/null || true
echo "   ✓ Hooks deployed to ~/.claude/hooks/"

# Register hooks in settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
HOOKS_JSON='{
  "hooks": {
    "PreToolUse": [{"matcher": "Write", "hooks": [{"type": "command", "command": "bash ~/.claude/hooks/guard-project-state.sh"}]}],
    "Stop": [{"type": "command", "command": "bash ~/.claude/hooks/suggest-checkpoint.sh"}],
    "UserPromptSubmit": [{"type": "command", "command": "bash ~/.claude/hooks/session-reminder.sh"}]
  }
}'

if [ ! -f "$SETTINGS" ]; then
  echo "$HOOKS_JSON" > "$SETTINGS"
  echo "   ✓ Hooks registered in ~/.claude/settings.json"
elif grep -q '"PreToolUse"' "$SETTINGS" 2>/dev/null; then
  echo "   ⚠️  Hooks already in settings.json — skipped (verify manually if needed)"
elif command -v python3 >/dev/null 2>&1; then
  python3 - "$SETTINGS" "$HOOKS_JSON" <<'PYEOF'
import sys, json
settings_path = sys.argv[1]
new_hooks = json.loads(sys.argv[2])
with open(settings_path) as f:
  settings = json.load(f)
settings.setdefault("hooks", {}).update(new_hooks["hooks"])
with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)
PYEOF
  echo "   ✓ Hooks merged into ~/.claude/settings.json"
else
  echo "   ⚠️  Could not auto-merge settings.json (python3 not found)"
  echo "      Add manually to ~/.claude/settings.json:"
  echo "$HOOKS_JSON"
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
echo "  ✓ Hooks: guard, suggest-checkpoint, session-reminder"
echo ""
