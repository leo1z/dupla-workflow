#!/bin/bash
# Guard: Prevent writes if PROJECT_STATE.md doesn't exist
# Hook: PreToolUse (triggered before Write tool)

if [ ! -f "docs/PROJECT_STATE.md" ]; then
  echo "❌ BLOCKED: docs/PROJECT_STATE.md not found"
  echo ""
  echo "This project needs workflow initialization:"
  echo "  • First time? Run: /adapt-project"
  echo "  • New project? Run: /new-project"
  echo ""
  echo "Or create docs/PROJECT_STATE.md manually from:"
  echo "  ~/.claude/templates/PROJECT_STATE_TEMPLATE.md"
  exit 1
fi

exit 0
