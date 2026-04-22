#!/bin/bash
# Suggestion: Remind user to run /checkpoint if files modified
# Hook: Stop (triggered when session closes)

if [ -z "$(git status --short)" ]; then
  # No changes
  exit 0
fi

# Has uncommitted changes
# Count commits since PROJECT_STATE.md was last updated
commit_count=$(git log --oneline -1 -- docs/PROJECT_STATE.md 2>/dev/null | wc -l)
if [ "$commit_count" -eq 0 ]; then
  commit_count=$(git log --oneline | wc -l)
fi

echo ""
echo "📌 Files modified ($commit_count commits since last PROJECT_STATE update)."
echo "   /checkpoint quick — for mid-session saves"
echo "   /checkpoint close — for full session closure + update state"
echo ""
exit 0
