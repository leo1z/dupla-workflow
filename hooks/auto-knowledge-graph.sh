#!/bin/bash
# Hook: Stop — auto-update of knowledge graph after each response
# Reports success or skip reason so Claude can surface issues if needed.

if [ ! -f "bin/generate-code-review-graph.sh" ]; then
  exit 0
fi

# Only run if project has meaningful structure (not an empty dir)
if [ ! -f "docs/PROJECT_STATE.md" ] && [ ! -f "QUICKSTATE.md" ]; then
  exit 0
fi

if bash bin/generate-code-review-graph.sh . > /dev/null 2>&1; then
  : # success — silent
else
  echo "⚠️ Knowledge graph update failed. Run: bash bin/generate-code-review-graph.sh"
fi

exit 0
