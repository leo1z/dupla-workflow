#!/bin/bash
# Hook: PreToolUse (Write) — blocks writes in Dupla projects without PROJECT_STATE.md
# Reads the target file_path from stdin JSON to allow PROJECT_STATE.md creation itself.

# Not a dupla-workflow project → allow all writes
if [ ! -f "CLAUDE.md" ] && [ ! -f ".cursorrules" ] && [ ! -f ".windsurfrules" ]; then
  exit 0
fi

# Parse target file path from stdin JSON
# Fail-closed for security guards: if we can't read the target, block rather than allow.
STDIN_DATA=$(cat)
TARGET=""

if command -v python3 >/dev/null 2>&1; then
  TARGET=$(echo "$STDIN_DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except:
    print('')
" 2>/dev/null)
elif command -v jq >/dev/null 2>&1; then
  TARGET=$(echo "$STDIN_DATA" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
else
  # No JSON parser — cannot verify target file. Fail-closed.
  echo "❌ BLOCKED: guard-project-state.sh requires python3 or jq to verify write target."
  echo "   Install python3: https://python.org/downloads (mark 'Add to PATH')"
  echo "   Or install jq:   https://jqlang.github.io/jq/download/"
  exit 1
fi

# Normalize separators
TARGET=$(echo "$TARGET" | sed 's|\\|/|g')

# Allow writes that ARE the initialization files themselves
case "$TARGET" in
  */docs/PROJECT_STATE.md|*/QUICKSTATE.md|*/CLAUDE.md|*/.cursorrules|*/.windsurfrules|*/docs/SPEC.md)
    exit 0
    ;;
esac

# Allow if PROJECT_STATE.md already exists
if [ -f "docs/PROJECT_STATE.md" ] || [ -f "QUICKSTATE.md" ]; then
  exit 0
fi

# Block: project is Dupla-initialized but missing state doc
echo "❌ BLOCKED: docs/PROJECT_STATE.md not found"
echo ""
echo "Initialize this project first:"
echo "  New project:      /new-project"
echo "  Existing project: /adapt-project"
echo "  Quick session:    /quick-start  (creates QUICKSTATE.md)"
exit 1
