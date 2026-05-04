#!/bin/bash
# Dupla-Workflow Installation Script
# Deploys to Claude Code, Antigravity (Gemini), and Cursor
# Usage: bash bin/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENT_BASE_DIR=""      # root of Antigravity install (e.g. ~/.gemini/antigravity)
AGENT_RULES_DIR=""     # knowledge/ — skills with trigger: agent_requested
AGENT_WORKFLOWS_DIR="" # global_workflows/ — skills with description: frontmatter
SKILLS_SOURCE="$SCRIPT_DIR/skills"
TEMPLATES_SOURCE="$SCRIPT_DIR/templates"
GLOBAL_TEMPLATES_SOURCE="$SCRIPT_DIR/global-templates"

echo "Dupla-Workflow Installation"
echo "==========================="

# --- STEP 1: Detect IDEs BEFORE creating any directories ---
HAS_CLAUDE=false
HAS_ANTIGRAVITY=false
HAS_CURSOR=false

[ -d "$CLAUDE_DIR" ] && HAS_CLAUDE=true

# Cursor detection
CURSOR_COMMANDS_DIR=""
if command -v cursor >/dev/null 2>&1; then
  HAS_CURSOR=true
fi
for d in "$HOME/.cursor" "$APPDATA/.cursor" "$(echo "$USERPROFILE" | sed 's|\\|/|g')/.cursor"; do
  if [ -d "$d" ]; then
    HAS_CURSOR=true
    CURSOR_COMMANDS_DIR="$d/commands"
    break
  fi
done

# Antigravity detection — priority order, first match wins
# Structure: <base>/knowledge/ (trigger:agent_requested) + <base>/global_workflows/ (description:)
detect_antigravity() {
  local base="$1"
  if [ -d "$base" ]; then
    AGENT_BASE_DIR="$base"
    AGENT_RULES_DIR="$base/knowledge"
    AGENT_WORKFLOWS_DIR="$base/global_workflows"
    HAS_ANTIGRAVITY=true
    return 0
  fi
  return 1
}

# 1. Explicit override (ANTIGRAVITY_DIR env var)
if [ -n "$ANTIGRAVITY_DIR" ]; then
  detect_antigravity "$ANTIGRAVITY_DIR"
fi

# 2. Unix default: ~/.gemini/antigravity
if [ "$HAS_ANTIGRAVITY" = false ]; then
  detect_antigravity "$HOME/.gemini/antigravity"
fi

# 3. Windows: USERPROFILE/.gemini/antigravity (confirmed path on Windows)
if [ "$HAS_ANTIGRAVITY" = false ] && [ -n "$USERPROFILE" ]; then
  WIN_GEMINI_DIR=$(echo "$USERPROFILE" | sed 's|\\|/|g')"/.gemini/antigravity"
  detect_antigravity "$WIN_GEMINI_DIR"
fi

# 4. Legacy: ~/.agent (older Antigravity versions used rules/ not knowledge/)
if [ "$HAS_ANTIGRAVITY" = false ]; then
  if [ -d "$HOME/.agent" ]; then
    AGENT_BASE_DIR="$HOME/.agent"
    AGENT_RULES_DIR="$HOME/.agent/rules"
    AGENT_WORKFLOWS_DIR=""  # old version had no global_workflows
    HAS_ANTIGRAVITY=true
  fi
fi

if [ "$HAS_ANTIGRAVITY" = false ] && command -v antigravity >/dev/null 2>&1; then
  echo "⚠️  Antigravity binary found but config directory not detected."
  echo "   Run: find ~ -maxdepth 5 -name 'knowledge' -path '*/antigravity/*' 2>/dev/null"
  echo "   Then re-run: ANTIGRAVITY_DIR=<base-path> bash bin/install.sh"
fi

# --- STEP 2: Require at least one IDE ---
if [ "$HAS_CLAUDE" = false ] && [ "$HAS_ANTIGRAVITY" = false ] && [ "$HAS_CURSOR" = false ]; then
  echo "ERROR: No supported IDE detected (Claude Code, Antigravity, or Cursor)."
  echo "   Install at least one first, then re-run."
  exit 1
fi

# --- STEP 3: Create directories (only now, after IDE check) ---
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/templates"
[ "$HAS_ANTIGRAVITY" = true ] && mkdir -p "$AGENT_RULES_DIR"

# --- STEP 4: Deploy skills ---
echo "📦 Deploying skills..."
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/skills/" 2>/dev/null || true
cp "$SKILLS_SOURCE"/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true

SKILL_COUNT=$(ls "$CLAUDE_DIR/skills/"*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$SKILL_COUNT" -eq 0 ]; then
  echo "   ❌ No skills deployed — check $SKILLS_SOURCE exists and has .md files"
  exit 1
fi
echo "   ✓ $SKILL_COUNT skills deployed to ~/.claude/skills/"
echo "   ✓ $SKILL_COUNT skills deployed to ~/.claude/commands/"

# Deploy skills — Antigravity knowledge/ (trigger: agent_requested)
if [ "$HAS_ANTIGRAVITY" = true ]; then
  mkdir -p "$AGENT_RULES_DIR"

  # Build list of current skill filenames (for stale cleanup)
  CURRENT_SKILLS=""
  for skill_file in "$SKILLS_SOURCE"/*.md; do
    CURRENT_SKILLS="$CURRENT_SKILLS $(basename "$skill_file")"
  done

  # Remove skills that no longer exist in source (orphan cleanup)
  REMOVED=0
  for existing in "$AGENT_RULES_DIR"/*.md; do
    [ -f "$existing" ] || continue
    fname=$(basename "$existing")
    # Never delete CLAUDE.md (global identity) or DUPLA_VERSION
    [ "$fname" = "CLAUDE.md" ] && continue
    if ! echo "$CURRENT_SKILLS" | grep -qw "$fname"; then
      rm -f "$existing"
      REMOVED=$((REMOVED + 1))
    fi
  done

  # Deploy current skills with trigger: agent_requested frontmatter
  for skill_file in "$SKILLS_SOURCE"/*.md; do
    fname=$(basename "$skill_file")
    dest="$AGENT_RULES_DIR/$fname"
    if ! grep -q "^trigger:" "$skill_file" 2>/dev/null; then
      printf -- "---\ntrigger: agent_requested\n---\n\n" > "$dest"
      cat "$skill_file" >> "$dest"
    else
      cp "$skill_file" "$dest"
    fi
  done

  AG_COUNT=$(ls "$AGENT_RULES_DIR"/*.md 2>/dev/null | grep -v CLAUDE.md | wc -l | tr -d ' ')
  echo "   ✓ $AG_COUNT skills deployed to $AGENT_RULES_DIR"
  [ "$REMOVED" -gt 0 ] && echo "   🗑  $REMOVED obsolete skills removed from knowledge/"
fi

# Deploy skills — Antigravity global_workflows/ (description: frontmatter for workflow picker)
if [ "$HAS_ANTIGRAVITY" = true ] && [ -n "$AGENT_WORKFLOWS_DIR" ]; then
  mkdir -p "$AGENT_WORKFLOWS_DIR"

  # Orphan cleanup in global_workflows — only remove files deployed by dupla (have description: frontmatter)
  for existing in "$AGENT_WORKFLOWS_DIR"/*.md; do
    [ -f "$existing" ] || continue
    fname=$(basename "$existing")
    if ! echo "$CURRENT_SKILLS" | grep -qw "$fname"; then
      # Only delete if this file was previously deployed by dupla (has description: header)
      if grep -q "^description:" "$existing" 2>/dev/null; then
        rm -f "$existing"
      fi
    fi
  done

  for skill_file in "$SKILLS_SOURCE"/*.md; do
    fname=$(basename "$skill_file")
    dest="$AGENT_WORKFLOWS_DIR/$fname"
    desc=$(grep -m1 "^[^#]" "$skill_file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-200)
    printf -- "---\ndescription: %s\n---\n\n" "$desc" > "$dest"
    cat "$skill_file" >> "$dest"
  done
  echo "   ✓ Workflows deployed to $AGENT_WORKFLOWS_DIR"
fi

# Deploy skills — Cursor
if [ "$HAS_CURSOR" = true ] && [ -n "$CURSOR_COMMANDS_DIR" ]; then
  mkdir -p "$CURSOR_COMMANDS_DIR"
  cp "$SKILLS_SOURCE"/*.md "$CURSOR_COMMANDS_DIR/" 2>/dev/null || true
  echo "   ✓ Skills deployed to $CURSOR_COMMANDS_DIR (Cursor slash commands)"
fi

# --- STEP 5: Deploy hooks ---
echo "🔧 Deploying hooks..."
mkdir -p "$CLAUDE_DIR/hooks"
cp "$SCRIPT_DIR/hooks"/*.sh "$CLAUDE_DIR/hooks/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/hooks"/*.sh 2>/dev/null || true

HOOK_COUNT=$(ls "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null | wc -l | tr -d ' ')
if [ "$HOOK_COUNT" -eq 0 ]; then
  echo "   ⚠️  No hooks deployed — check $SCRIPT_DIR/hooks/ exists"
else
  echo "   ✓ $HOOK_COUNT hooks deployed to ~/.claude/hooks/"
fi

# Register hooks in settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
HOOKS_JSON='{
  "hooks": {
    "PreToolUse": [
      {"matcher": "Write", "hooks": [{"type": "command", "command": "bash ~/.claude/hooks/guard-project-state.sh"}]},
      {"matcher": "Bash", "hooks": [{"type": "command", "command": "bash ~/.claude/hooks/hitl-guard.sh"}]}
    ],
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
  echo "   ⚠️  Hooks already in settings.json — skipped (verify with /health-check)"
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
  existing_cmds = set()
  for e in existing[event]:
    if isinstance(e, dict) and "command" in e:
      existing_cmds.add(e["command"])
    elif isinstance(e, dict) and "hooks" in e:
      for h in e.get("hooks", []):
        existing_cmds.add(h.get("command", ""))
  for new_entry in entries:
    new_cmd = new_entry.get("command") or ""
    if not new_cmd:
      new_cmd = " ".join(h.get("command","") for h in new_entry.get("hooks",[]))
    if new_cmd not in existing_cmds:
      existing[event].append(new_entry)

with open(settings_path, "w") as f:
  json.dump(settings, f, indent=2)
PYEOF
  echo "   ✓ Hooks merged into ~/.claude/settings.json"
else
  echo "   ⚠️  Could not auto-merge settings.json (python3 not found)"
  echo "      Add manually to ~/.claude/settings.json:"
  echo "$HOOKS_JSON"
fi

# --- STEP 6: Sync CLAUDE.md → GEMINI.md ---
# Only sync if CLAUDE.md exists AND has real content (not empty/placeholder)
GEMINI_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_DIR"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ -s "$CLAUDE_DIR/CLAUDE.md" ]; then
  CONTENT_LINES=$(grep -v '^#\|^---\|^$' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "${CONTENT_LINES:-0}" -gt 5 ]; then
    if [ ! -s "$GEMINI_DIR/GEMINI.md" ]; then
      cp "$CLAUDE_DIR/CLAUDE.md" "$GEMINI_DIR/GEMINI.md"
      echo "📌 ~/.gemini/GEMINI.md created from CLAUDE.md"
    else
      echo "   ✓ ~/.gemini/GEMINI.md already exists — skipped"
    fi
  else
    echo "   ⚠️  CLAUDE.md found but appears to be a placeholder — run /setup-dupla to fill it"
  fi
else
  echo "   ⚠️  ~/.claude/CLAUDE.md not found — run /setup-dupla to generate it"
fi

# Sync CLAUDE.md to Antigravity knowledge/ as always_on rule (always update)
if [ "$HAS_ANTIGRAVITY" = true ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ -s "$CLAUDE_DIR/CLAUDE.md" ]; then
  AGENT_CLAUDE="$AGENT_RULES_DIR/CLAUDE.md"
  printf -- "---\ntrigger: always_on\n---\n\n" > "$AGENT_CLAUDE"
  cat "$CLAUDE_DIR/CLAUDE.md" >> "$AGENT_CLAUDE"
  echo "   ✓ CLAUDE.md synced to $AGENT_RULES_DIR/CLAUDE.md (trigger: always_on)"
fi

# --- STEP 7: Version marker ---
echo "$(cat "$SCRIPT_DIR/VERSION")" > "$CLAUDE_DIR/DUPLA_VERSION"
[ "$HAS_ANTIGRAVITY" = true ] && cp "$CLAUDE_DIR/DUPLA_VERSION" "$AGENT_RULES_DIR/DUPLA_VERSION" 2>/dev/null || true

# --- STEP 8: .claudeignore ---
if [ ! -f "$SCRIPT_DIR/.claudeignore" ]; then
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
fi

# --- STEP 9: Project Doctor ---
echo ""
echo "🩺 Project Doctor: Checking current directory..."
if [ -f "docs/PROJECT_STATE.md" ]; then
  echo "   ✓ Dupla OS project detected."
  if ! grep -q "project_type:" "docs/PROJECT_STATE.md"; then
    echo "   ⚠️  Missing 'project_type' in PROJECT_STATE.md. Defaulting to 'individual'."
    sed -i 's/<session>/<session>\nproject_type: individual/' "docs/PROJECT_STATE.md" 2>/dev/null || true
  fi
  if ! grep -q "Mode:" "docs/PROJECT_STATE.md"; then
    echo "   ⚠️  Missing 'Mode' in PROJECT_STATE.md. Defaulting to 'full'."
    sed -i 's/Status: /Mode: full\nStatus: /' "docs/PROJECT_STATE.md" 2>/dev/null || true
  fi
  if [ ! -f "docs/ROADMAP.md" ]; then
    echo "   ⚠️  docs/ROADMAP.md missing. Run /check-project to generate it."
  fi
else
  echo "   ℹ️  No project detected here. Run /new-project when ready."
fi

# --- STEP 10: Post-install validation summary ---
echo ""
echo "✅ Installation complete!"
echo ""
echo "IDEs configured:"
[ "$HAS_CLAUDE" = true ] && echo "  ✓ Claude Code — $SKILL_COUNT skills + $HOOK_COUNT hooks"
[ "$HAS_ANTIGRAVITY" = true ] && echo "  ✓ Antigravity — rules ($AGENT_RULES_DIR) + workflows"
[ "$HAS_CURSOR" = true ] && echo "  ✓ Cursor — slash commands ($CURSOR_COMMANDS_DIR)"
echo ""

# Warn if CLAUDE.md still missing — this is a required next step
if [ ! -s "$CLAUDE_DIR/CLAUDE.md" ] || [ "$(grep -v '^#\|^---\|^$' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null | wc -l | tr -d ' ')" -le 5 ]; then
  echo "⚠️  REQUIRED NEXT STEP:"
  echo "   ~/.claude/CLAUDE.md is missing or empty."
  echo "   You must run /setup-dupla before using Dupla OS."
  echo "   Without it, Claude has no identity, no routing, and Gemini won't sync."
  echo ""
fi

echo "Next steps:"
echo "  1. /setup-dupla  ← if first time (generates CLAUDE.md + SYSTEM.md)"
echo "  2. /health-check ← verify everything is wired correctly"
echo "  3. /new-project or /adapt-project ← start or onboard a project"
echo ""
echo "Per-project setup: /adapt-project in any project"
echo "  → Creates .agents/rules/ (project rules for Gemini)"
echo ""
