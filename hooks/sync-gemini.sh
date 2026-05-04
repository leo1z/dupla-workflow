#!/bin/bash
# Hook: PostToolUse (Write) — syncs ~/.claude/CLAUDE.md to ~/.gemini/GEMINI.md
# Claude Code delivers hook input as JSON via stdin.
# Field: .tool_input.file_path — the absolute path of the file just written.

CLAUDE_GLOBAL="$HOME/.claude/CLAUDE.md"
GEMINI_DIR="$HOME/.gemini"
GEMINI_MD="$GEMINI_DIR/GEMINI.md"

# Read stdin JSON — parse file_path written by the Write tool
if command -v python3 >/dev/null 2>&1; then
  FILE_PATH=$(python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except:
    print('')
" 2>/dev/null)
elif command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
else
  exit 0
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize path separators (Windows Git Bash uses mixed slashes)
FILE_PATH_NORM=$(echo "$FILE_PATH" | sed 's|\\|/|g')
CLAUDE_GLOBAL_NORM=$(echo "$CLAUDE_GLOBAL" | sed 's|\\|/|g')

# Only act when the file written is the global CLAUDE.md
if [ "$FILE_PATH_NORM" != "$CLAUDE_GLOBAL_NORM" ]; then
  exit 0
fi

# Only sync if ~/.gemini/ exists (Antigravity/Gemini CLI installed)
if [ ! -d "$GEMINI_DIR" ]; then
  exit 0
fi

cp "$CLAUDE_GLOBAL" "$GEMINI_MD" 2>/dev/null
exit 0
