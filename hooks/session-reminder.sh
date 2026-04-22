#!/bin/bash
# Hook: UserPromptSubmit — warns once per session if PROJECT_STATE is stale
# Uses a session marker to avoid injecting text on every message

if [ ! -f "docs/PROJECT_STATE.md" ]; then
  exit 0
fi

# Only fire once per session
MARKER=".tmp/session-reminder-fired"
if [ -f "$MARKER" ]; then
  exit 0
fi

UPDATED=$(grep "^updated:" docs/PROJECT_STATE.md | head -1 | cut -d' ' -f2)
if [ -z "$UPDATED" ]; then
  exit 0
fi

if date -d "$UPDATED" +%s >/dev/null 2>&1; then
  UPDATED_EPOCH=$(date -d "$UPDATED" +%s)
else
  UPDATED_EPOCH=$(date -j -f "%Y-%m-%d" "$UPDATED" +%s 2>/dev/null)
fi

NOW_EPOCH=$(date +%s)
DIFF_HOURS=$(( (NOW_EPOCH - UPDATED_EPOCH) / 3600 ))

if [ "$DIFF_HOURS" -gt 24 ]; then
  mkdir -p .tmp
  touch "$MARKER"
  echo "⚠️ Session state is $(($DIFF_HOURS / 24))d old. Run /new-session to refresh."
  echo ""
fi

exit 0
