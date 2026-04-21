#!/bin/bash
# Guard: Prevent writes in dupla-workflow projects without PROJECT_STATE.md
# Hook: PreToolUse (triggered before Write tool)
# Only enforces if CLAUDE.md exists (indicates dupla-workflow project)

if [ ! -f "CLAUDE.md" ]; then
  # Not a dupla-workflow project, allow writes
  exit 0
fi

# This is a dupla-workflow project — check for PROJECT_STATE.md
if [ ! -f "docs/PROJECT_STATE.md" ]; then
  echo "❌ BLOCKED: docs/PROJECT_STATE.md not found"
  echo ""
  echo "This dupla-workflow project needs initialization:"
  echo "  • Existing project? Run: /adapt-project"
  echo "  • New project? Run: /new-project"
  echo ""
  echo "Or create docs/PROJECT_STATE.md manually from:"
  echo "  ~/.claude/templates/PROJECT_STATE_TEMPLATE.md"
  exit 1
fi

exit 0
