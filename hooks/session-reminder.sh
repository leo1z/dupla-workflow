#!/bin/bash
# Hook: UserPromptSubmit — warns once per session if PROJECT_STATE is stale
# Uses a session marker to avoid injecting text on every message

if [ ! -f "docs/PROJECT_STATE.md" ]; then
  exit 0
fi

# Cross-platform hash: Python3 primary (works on Windows Git Bash), fallback to cksum
PROJECT_HASH=$(python3 -c "import hashlib; print(hashlib.md5('$PWD'.encode()).hexdigest()[:8])" 2>/dev/null \
  || echo "$PWD" | cksum | cut -d' ' -f1 2>/dev/null \
  || echo "default")
# Cross-platform temp dir: TMPDIR (macOS/Linux) → TEMP (Windows) → /tmp
TMPDIR_DUPLA="${TMPDIR:-${TEMP:-/tmp}}/dupla-hooks-$PROJECT_HASH"
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

# Cross-platform date parsing: Python3 primary, then Linux date -d, then macOS date -j
UPDATED_EPOCH=""
if command -v python3 >/dev/null 2>&1; then
  UPDATED_EPOCH=$(python3 -c "import datetime,time; d=datetime.datetime.strptime('$UPDATED','%Y-%m-%d'); print(int(time.mktime(d.timetuple())))" 2>/dev/null)
elif date -d "$UPDATED" +%s >/dev/null 2>&1; then
  UPDATED_EPOCH=$(date -d "$UPDATED" +%s)
elif date -j -f "%Y-%m-%d" "$UPDATED" +%s >/dev/null 2>&1; then
  UPDATED_EPOCH=$(date -j -f "%Y-%m-%d" "$UPDATED" +%s 2>/dev/null)
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
