#!/bin/bash
# Hook: PostToolUse (Write) — syncs ~/.claude/CLAUDE.md to ~/.gemini/GEMINI.md
# Fires after any Write tool call. Only acts when the written file is CLAUDE.md global.

CLAUDE_GLOBAL="$HOME/.claude/CLAUDE.md"
GEMINI_DIR="$HOME/.gemini"
GEMINI_MD="$GEMINI_DIR/GEMINI.md"

# Check if the tool input references the global CLAUDE.md
# CLAUDE_CODE_TOOL_INPUT is set by the hook environment to the file path written
INPUT="${CLAUDE_CODE_TOOL_INPUT:-}"
if [ -z "$INPUT" ]; then
  exit 0
fi

# Only act when the written file is the global CLAUDE.md
case "$INPUT" in
  *"/.claude/CLAUDE.md"|*"\\.claude\\CLAUDE.md")
    ;;
  *)
    exit 0
    ;;
esac

# Only sync if Antigravity/Gemini is installed
if [ ! -d "$GEMINI_DIR" ]; then
  exit 0
fi

mkdir -p "$GEMINI_DIR"
cp "$CLAUDE_GLOBAL" "$GEMINI_MD" 2>/dev/null

exit 0
