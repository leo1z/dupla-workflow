#!/bin/bash
# Dupla-Workflow Installation Script
# Deploys to Claude Code, Antigravity (Gemini), and Cursor
# Usage: bash bin/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENT_DIR="$HOME/.agent"
AGENT_RULES_DIR=""
AGENT_WORKFLOWS_DIR="$HOME/.gemini/antigravity/global_workflows"
SKILLS_SOURCE="$SCRIPT_DIR/skills"
TEMPLATES_SOURCE="$SCRIPT_DIR/templates"
GLOBAL_TEMPLATES_SOURCE="$SCRIPT_DIR/global-templates"

echo "Dupla-Workflow Installation"
echo "==========================="

# Detect IDEs
HAS_CLAUDE=false
HAS_ANTIGRAVITY=false
HAS_CURSOR=false

[ -d "$CLAUDE_DIR" ] && HAS_CLAUDE=true

# Cursor detection — check for .cursor/commands/ or cursor CLI
CURSOR_COMMANDS_DIR=""
if command -v cursor >/dev/null 2>&1; then
  HAS_CURSOR=true
fi
# Check common Cursor user data paths
for d in "$HOME/.cursor" "$APPDATA/.cursor" "$(echo "$USERPROFILE" | sed 's|\\|/|g')/.cursor"; do
  if [ -d "$d" ]; then
    HAS_CURSOR=true
    CURSOR_COMMANDS_DIR="$d/commands"
    break
  fi
done

# Antigravity detection — check all known paths (Unix + Windows)
# Override: ANTIGRAVITY_DIR=/path bash bin/install.sh
if [ -n "$ANTIGRAVITY_DIR" ] && [ -d "$ANTIGRAVITY_DIR" ]; then
  AGENT_DIR="$ANTIGRAVITY_DIR"
  AGENT_RULES_DIR="$ANTIGRAVITY_DIR/knowledge"
  HAS_ANTIGRAVITY=true
fi

[ -d "$AGENT_DIR" ] && HAS_ANTIGRAVITY=true && AGENT_RULES_DIR="$AGENT_DIR/rules"

# Windows: ~/.gemini/antigravity/ (confirmed path on Windows)
if [ "$HAS_ANTIGRAVITY" = false ]; then
  GEMINI_AGENT_DIR="$HOME/.gemini/antigravity"
  if [ -d "$GEMINI_AGENT_DIR" ]; then
    AGENT_DIR="$GEMINI_AGENT_DIR"
    AGENT_RULES_DIR="$GEMINI_AGENT_DIR/knowledge"
    HAS_ANTIGRAVITY=true
  fi
fi

# Windows fallback: USERPROFILE/.agent
if [ "$HAS_ANTIGRAVITY" = false ] && [ -n "$USERPROFILE" ]; then
  WIN_AGENT_DIR=$(echo "$USERPROFILE" | sed 's|\\|/|g')"/.agent"
  if [ -d "$WIN_AGENT_DIR" ]; then
    AGENT_DIR="$WIN_AGENT_DIR"
    AGENT_RULES_DIR="$WIN_AGENT_DIR/rules"
    HAS_ANTIGRAVITY=true
  fi
fi

# Windows fallback: USERPROFILE/.gemini/antigravity
if [ "$HAS_ANTIGRAVITY" = false ] && [ -n "$USERPROFILE" ]; then
  WIN_GEMINI_DIR=$(echo "$USERPROFILE" | sed 's|\\|/|g')"/.gemini/antigravity"
  if [ -d "$WIN_GEMINI_DIR" ]; then
    AGENT_DIR="$WIN_GEMINI_DIR"
    AGENT_RULES_DIR="$WIN_GEMINI_DIR/knowledge"
    HAS_ANTIGRAVITY=true
  fi
fi

if [ "$HAS_ANTIGRAVITY" = false ] && command -v antigravity >/dev/null 2>&1; then
  echo "⚠️  Antigravity binary found but config directory not detected."
  echo "   Run this to find it:"
  echo "     find ~ -maxdepth 4 -name 'antigravity' -type d 2>/dev/null"
  echo "   Then re-run: ANTIGRAVITY_DIR=<path> bash bin/install.sh"
fi

if [ "$HAS_CLAUDE" = false ] && [ "$HAS_ANTIGRAVITY" = false ] && [ "$HAS_CURSOR" = false ]; then
  echo "ERROR: No supported IDE detected (Claude Code, Antigravity, or Cursor)."
  echo "   Install at least one first, then re-run."
  exit 1
fi

# Create directories if needed
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/templates"
[ "$HAS_ANTIGRAVITY" = true ] && mkdir -p "$AGENT_RULES_DIR"

# Deploy skills — Claude Code
echo "📦 Deploying skills..."
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/skills/" 2>/dev/null || true
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true
echo "   ✓ Skills deployed to ~/.claude/skills/"
echo "   ✓ Skills deployed to ~/.claude/commands/ (slash commands)"

# Deploy skills — Antigravity (knowledge/ dir, add trigger frontmatter if missing)
if [ "$HAS_ANTIGRAVITY" = true ]; then
  for skill_file in "$SKILLS_SOURCE"/*.md; do
    fname=$(basename "$skill_file")
    dest="$AGENT_RULES_DIR/$fname"
    # Prepend trigger frontmatter if not present
    if ! grep -q "^trigger:" "$skill_file" 2>/dev/null; then
      printf -- "---\ntrigger: agent_requested\n---\n\n" > "$dest"
      cat "$skill_file" >> "$dest"
    else
      cp "$skill_file" "$dest"
    fi
  done
  echo "   ✓ Skills deployed to $AGENT_RULES_DIR (Antigravity)"
fi

# Deploy skills — Cursor (slash commands via .cursor/commands/)
if [ "$HAS_CURSOR" = true ] && [ -n "$CURSOR_COMMANDS_DIR" ]; then
  mkdir -p "$CURSOR_COMMANDS_DIR"
  cp "$SKILLS_SOURCE"/*.md "$CURSOR_COMMANDS_DIR/" 2>/dev/null || true
  echo "   ✓ Skills deployed to $CURSOR_COMMANDS_DIR (Cursor slash commands)"
fi

# Deploy skills — Antigravity Workflows (type "/" to trigger in Agent)
mkdir -p "$AGENT_WORKFLOWS_DIR"
for skill_file in "$SKILLS_SOURCE"/*.md; do
  fname=$(basename "$skill_file")
  name="${fname%.md}"
  dest="$AGENT_WORKFLOWS_DIR/$fname"
  desc=$(grep -m1 "^[^#]" "$skill_file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-200)
  printf -- "---\ndescription: %s\n---\n\n" "$desc" > "$dest"
  cat "$skill_file" >> "$dest"
done
echo "   ✓ Workflows deployed to ~/.gemini/antigravity/global_workflows/ (type /skill-name in Antigravity)"

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

# Sync ~/.claude/CLAUDE.md → ~/.gemini/GEMINI.md (global Gemini identity)
GEMINI_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_DIR"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  if [ ! -s "$GEMINI_DIR/GEMINI.md" ]; then
    echo "📌 Creating ~/.gemini/GEMINI.md from CLAUDE.md..."
    cp "$CLAUDE_DIR/CLAUDE.md" "$GEMINI_DIR/GEMINI.md"
    echo "   ✓ ~/.gemini/GEMINI.md created"
  else
    echo "   ✓ ~/.gemini/GEMINI.md already exists — skipped"
  fi
fi

# Sync CLAUDE.md to Antigravity knowledge/ as always_on rule (fallback for older Antigravity)
if [ "$HAS_ANTIGRAVITY" = true ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  AGENT_CLAUDE="$AGENT_RULES_DIR/CLAUDE.md"
  if [ ! -f "$AGENT_CLAUDE" ]; then
    printf -- "---\ntrigger: always_on\n---\n\n" > "$AGENT_CLAUDE"
    cat "$CLAUDE_DIR/CLAUDE.md" >> "$AGENT_CLAUDE"
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
    "Stop": [
      {"type": "command", "command": "bash ~/.claude/hooks/suggest-checkpoint.sh"},
      {"type": "command", "command": "bash ~/.claude/hooks/auto-snapshot.sh"},
      {"type": "command", "command": "bash ~/.claude/hooks/auto-knowledge-graph.sh"}
    ],
    "UserPromptSubmit": [{"type": "command", "command": "bash ~/.claude/hooks/session-reminder.sh"}],
    "PostToolUse": [{"matcher": "Write", "hooks": [{"type": "command", "command": "bash ~/.claude/hooks/sync-gemini.sh"}]}]
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
new_hooks_raw = json.loads(sys.argv[2])["hooks"]

with open(settings_path) as f:
  settings = json.load(f)

existing = settings.setdefault("hooks", {})

for event, entries in new_hooks_raw.items():
  if event not in existing:
    existing[event] = entries
    continue
  # Append only entries whose command is not already present
  existing_cmds = set()
  for e in existing[event]:
    # Stop/UserPromptSubmit: entries are {"type","command"}
    if isinstance(e, dict) and "command" in e:
      existing_cmds.add(e["command"])
    # PreToolUse/PostToolUse: entries are {"matcher","hooks":[...]}
    elif isinstance(e, dict) and "hooks" in e:
      for h in e.get("hooks", []):
        existing_cmds.add(h.get("command", ""))
  for new_entry in entries:
    new_cmd = new_entry.get("command") or ""
    if not new_cmd:
      # structured entry (PreToolUse style) — check inner hooks
      new_cmd = " ".join(h.get("command","") for h in new_entry.get("hooks",[]))
    if new_cmd not in existing_cmds:
      existing[event].append(new_entry)

with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)
PYEOF
  echo "   ✓ Hooks merged into ~/.claude/settings.json (append-only, no overwrites)"
else
  echo "   ⚠️  Could not auto-merge settings.json (python3 not found)"
  echo "      Add manually to ~/.claude/settings.json:"
  echo "$HOOKS_JSON"
fi

# Create dupla version marker
echo "$(cat "$SCRIPT_DIR/VERSION")" > "$CLAUDE_DIR/DUPLA_VERSION"
[ "$HAS_ANTIGRAVITY" = true ] && cp "$CLAUDE_DIR/DUPLA_VERSION" "$AGENT_RULES_DIR/DUPLA_VERSION"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Run: /setup-dupla"
echo "  2. Or if migrating: /adapt-project"
echo ""
echo "IDEs configured:"
[ "$HAS_CLAUDE" = true ] && echo "  ✓ Claude Code — skills (~/.claude/skills/) + hooks"
[ "$HAS_ANTIGRAVITY" = true ] && echo "  ✓ Antigravity — global rules ($AGENT_RULES_DIR)"
[ "$HAS_ANTIGRAVITY" = true ] && echo "  ✓ Antigravity — global workflows (~/.gemini/antigravity/global_workflows/)"
[ "$HAS_ANTIGRAVITY" = true ] && echo "  ✓ Gemini identity (~/.gemini/GEMINI.md)"
[ "$HAS_CURSOR" = true ] && echo "  ✓ Cursor — slash commands ($CURSOR_COMMANDS_DIR)"
echo ""
echo "Hooks (Claude Code only — no hook support in Cursor/Windsurf/Gemini):"
echo "  guard-project-state, suggest-checkpoint, session-reminder, auto-snapshot, sync-gemini"
echo ""
echo "Per-project setup: run /adapt-project in any project"
echo "  → Creates .agents/rules/ (project rules for Gemini)"
echo "  → Creates .agents/workflows/ (project workflows)"
echo ""

# --- PROJECT DOCTOR (Auto-upgrade local project if detected) ---
echo "🩺 Project Doctor: Checking current directory..."
if [ -f "docs/PROJECT_STATE.md" ]; then
  echo "   ✓ Dupla OS project detected in current directory."
  
  # Check for missing project_type
  if ! grep -q "project_type:" "docs/PROJECT_STATE.md"; then
    echo "   ⚠️  Missing 'project_type' in PROJECT_STATE.md. Defaulting to 'individual'."
    # Safely inject it after <session> or at the top
    sed -i 's/<session>/<session>\nproject_type: individual/' "docs/PROJECT_STATE.md" 2>/dev/null || true
  fi

  # Check for missing Mode
  if ! grep -q "Mode:" "docs/PROJECT_STATE.md"; then
    echo "   ⚠️  Missing 'Mode' in PROJECT_STATE.md. Defaulting to 'full'."
    sed -i 's/Status: /Mode: full\nStatus: /' "docs/PROJECT_STATE.md" 2>/dev/null || true
  fi

  # Check for ROADMAP
  if [ ! -f "docs/ROADMAP.md" ]; then
    echo "   ⚠️  docs/ROADMAP.md is missing. Run /check-project in your IDE to generate it."
  fi
else
  echo "   ℹ️  No project detected in current directory. Run /new-project when ready."
fi
echo ""
