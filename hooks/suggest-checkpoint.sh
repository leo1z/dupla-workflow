#!/bin/bash
# Hook: Stop — fires when Claude finishes a response
# Suggests /checkpoint only when meaningful — avoids spamming context every turn

# Skip if no uncommitted changes
if [ -z "$(git status --short 2>/dev/null)" ]; then
  exit 0
fi

# Cross-platform hash: Python3 primary, fallback to cksum
PROJECT_HASH=$(python3 -c "import hashlib; print(hashlib.md5('$PWD'.encode()).hexdigest()[:8])" 2>/dev/null \
  || echo "$PWD" | cksum | cut -d' ' -f1 2>/dev/null \
  || echo "default")
# Cross-platform temp dir
TMPDIR_DUPLA="${TMPDIR:-${TEMP:-/tmp}}/dupla-hooks-$PROJECT_HASH"
mkdir -p "$TMPDIR_DUPLA"

# Detect default branch FIRST (main / master / develop / trunk)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH=$(git branch --list main master develop trunk 2>/dev/null | head -1 | tr -d ' *')
fi
if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH="main"
fi

# Throttle: only fire once per 3 stops using a counter file
COUNTER_FILE="$TMPDIR_DUPLA/checkpoint-counter"
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Count commits since PROJECT_STATE.md was last updated
state_commit=$(git log --oneline -1 -- docs/PROJECT_STATE.md 2>/dev/null | awk '{print $1}')
if [ -n "$state_commit" ]; then
  commits_since_state=$(git log "${state_commit}..HEAD" --oneline 2>/dev/null | wc -l | tr -d ' ')
else
  commits_since_state=$(git log "${DEFAULT_BRANCH}..HEAD" --oneline 2>/dev/null | wc -l | tr -d ' ')
  commits_since_state=${commits_since_state:-0}
fi

# Only speak when: state is very stale (>5 commits) OR every 3rd stop
if [ "${commits_since_state:-0}" -gt 5 ]; then
  echo ""
  echo "📌 $commits_since_state commits sin actualizar PROJECT_STATE — /checkpoint close recomendado"
  echo ""
  echo "0" > "$COUNTER_FILE"
elif [ "$COUNT" -ge 3 ] && [ "${commits_since_state:-0}" -gt 0 ]; then
  echo ""
  echo "📌 Cambios sin guardar. /checkpoint quick (mid-sesión) · /checkpoint close (cierre)"
  echo ""
  echo "0" > "$COUNTER_FILE"
fi

# Long session warning — only once per session
LONG_SESSION_MARKER="$TMPDIR_DUPLA/long-session-warned"
commits_since_main=$(git log "${DEFAULT_BRANCH}..HEAD" --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "${commits_since_main:-0}" -gt 10 ] && [ ! -f "$LONG_SESSION_MARKER" ]; then
  echo "💡 Sesión larga ($commits_since_main commits). /checkpoint close → nuevo chat → /new-session"
  echo ""
  touch "$LONG_SESSION_MARKER"
fi

exit 0
