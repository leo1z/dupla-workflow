#!/bin/bash
# Hook: Stop — auto-backup of docs/ when the LLM finishes a response
# Copies docs/ to _versions/<timestamp>/ regardless of git status
# Safe: never touches git stash (would corrupt user's own stash), never blocks

# Only act if docs/ directory exists and has content
if [ ! -d "docs" ] || [ -z "$(ls -A docs/ 2>/dev/null)" ]; then
  exit 0
fi

# Cross-platform timestamp
if command -v python3 >/dev/null 2>&1; then
  STAMP=$(python3 -c "import datetime; print(datetime.datetime.now().strftime('%Y-%m-%d_%H-%M'))")
else
  STAMP=$(date +%Y-%m-%d_%H-%M 2>/dev/null || echo "snapshot")
fi

SNAPSHOT_DIR="_versions/$STAMP"
mkdir -p "$SNAPSHOT_DIR"
cp -r docs/. "$SNAPSHOT_DIR/" 2>/dev/null

# Keep only the 10 most recent snapshots (LRU cleanup)
if command -v python3 >/dev/null 2>&1; then
  python3 -c "
import os, shutil
base = '_versions'
if os.path.isdir(base):
    entries = sorted(
        [e for e in os.listdir(base) if os.path.isdir(os.path.join(base, e))],
        reverse=True
    )
    for old in entries[10:]:
        shutil.rmtree(os.path.join(base, old), ignore_errors=True)
" 2>/dev/null
fi

exit 0
