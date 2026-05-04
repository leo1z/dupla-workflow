#!/bin/bash
# Hook: Stop — auto-backup of docs/ when Claude finishes a response
# With git: stashes docs/ changes so state is never lost if user skips /checkpoint
# Without git: creates a timestamped copy in _versions/ (for small projects)

# Only act if docs/ directory exists
if [ ! -d "docs" ]; then
  exit 0
fi

if git rev-parse --git-dir >/dev/null 2>&1; then
  # Project has git — stash only docs/ if there are uncommitted changes there
  if [ -n "$(git status --short docs/ 2>/dev/null)" ]; then
    STAMP=$(python3 -c "import datetime; print(datetime.datetime.now().strftime('%Y%m%d-%H%M'))" 2>/dev/null \
      || date +%Y%m%d-%H%M 2>/dev/null \
      || echo "snapshot")
    git stash push -q -m "auto-snapshot-$STAMP" -- docs/ 2>/dev/null
    # Immediately pop so docs/ changes are still visible (stash is just a safety copy)
    git stash pop -q 2>/dev/null
  fi
else
  # No git — timestamped copy to _versions/
  if command -v python3 >/dev/null 2>&1; then
    STAMP=$(python3 -c "import datetime; print(datetime.datetime.now().strftime('%Y-%m-%d_%H-%M'))")
  else
    STAMP=$(date +%Y-%m-%d_%H-%M 2>/dev/null || echo "snapshot")
  fi

  SNAPSHOT_DIR="_versions/$STAMP"
  mkdir -p "$SNAPSHOT_DIR"
  cp -r docs/ "$SNAPSHOT_DIR/" 2>/dev/null

  # Keep only the 10 most recent snapshots
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "
import os, shutil
base = '_versions'
if os.path.isdir(base):
    entries = sorted([e for e in os.listdir(base) if os.path.isdir(os.path.join(base,e))], reverse=True)
    for old in entries[10:]:
        shutil.rmtree(os.path.join(base, old), ignore_errors=True)
" 2>/dev/null
  fi
fi

exit 0
