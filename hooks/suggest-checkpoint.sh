#!/bin/bash
# Suggestion: Remind user to run /checkpoint if files modified
# Hook: Stop (triggered when session closes)

if [ -z "$(git status --short)" ]; then
  # No changes
  exit 0
fi

# Has uncommitted changes
echo ""
echo "📌 Files modified. Consider running /checkpoint to save state."
echo "   /checkpoint quick — for mid-session saves"
echo "   /checkpoint close — for full session closure"
echo ""
exit 0
