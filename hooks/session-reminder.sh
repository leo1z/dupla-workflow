#!/bin/bash
# Hook: UserPromptSubmit — warns once per session if PROJECT_STATE is stale
# Uses a session marker to avoid injecting text on every message
# GAP-01 fix: cross-platform date parsing (Linux / macOS / Windows Git Bash via Python3)
# GAP-02 fix: marker stored in system temp dir (outside repo, survives git clean)

if [ ! -f "docs/PROJECT_STATE.md" ]; then
  exit 0
fi

# Use system temp dir keyed by project path — survives git clean
PROJECT_HASH=$(echo "$PWD" | cksum | cut -d' ' -f1 2>/dev/null || echo "default")
TMPDIR_DUPLA="${TMPDIR:-/tmp}/dupla-hooks-$PROJECT_HASH"
mkdir -p "$TMPDIR_DUPLA"
MARKER="$TMPDIR_DUPLA/session-reminder-fired"

# Only fire once per session
if [ -f "$MARKER" ]; then
  exit 0
fi

UPDATED=$(grep "^updated:" docs/PROJECT_STATE.md | head -1 | cut -d' ' -f2)
if [ -z "$UPDATED" ]; then
  exit 0
fi

# Cross-platform date parsing: Linux → macOS → Python3 fallback (Windows Git Bash)
UPDATED_EPOCH=""
if date -d "$UPDATED" +%s >/dev/null 2>&1; then
  UPDATED_EPOCH=$(date -d "$UPDATED" +%s)
elif date -j -f "%Y-%m-%d" "$UPDATED" +%s >/dev/null 2>&1; then
  UPDATED_EPOCH=$(date -j -f "%Y-%m-%d" "$UPDATED" +%s 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  UPDATED_EPOCH=$(python3 -c "import datetime,time; d=datetime.datetime.strptime('$UPDATED','%Y-%m-%d'); print(int(time.mktime(d.timetuple())))" 2>/dev/null)
fi

if [ -z "$UPDATED_EPOCH" ]; then
  exit 0
fi

NOW_EPOCH=$(date +%s)
DIFF_HOURS=$(( (NOW_EPOCH - UPDATED_EPOCH) / 3600 ))

if [ "$DIFF_HOURS" -gt 24 ]; then
  touch "$MARKER"
  echo "⚠️ Session state is $(($DIFF_HOURS / 24))d old. Run /new-session to refresh."
  echo ""
fi

exit 0
