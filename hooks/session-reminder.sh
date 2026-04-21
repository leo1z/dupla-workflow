#!/bin/bash
# Reminder: Suggest /new-session if PROJECT_STATE is stale
# Hook: UserPromptSubmit (triggered on each user message)

if [ ! -f "docs/PROJECT_STATE.md" ]; then
  exit 0
fi

# Extract updated timestamp from YAML
UPDATED=$(grep "^updated:" docs/PROJECT_STATE.md | head -1 | cut -d' ' -f2)

if [ -z "$UPDATED" ]; then
  exit 0
fi

# Parse YYYY-MM-DD format
UPDATED_EPOCH=$(date -d "$UPDATED" +%s 2>/dev/null)
NOW_EPOCH=$(date +%s)
DIFF_SECONDS=$((NOW_EPOCH - UPDATED_EPOCH))
DIFF_HOURS=$((DIFF_SECONDS / 3600))

if [ $DIFF_HOURS -gt 24 ]; then
  echo "⚠️ Session state is $(($DIFF_HOURS / 24)) days old."
  echo "   Run /new-session to refresh context (reads from git + PROJECT_STATE)"
  echo ""
fi

exit 0
