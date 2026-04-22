#!/bin/bash
# Hook: Stop — fires when Claude finishes a response
# Suggests /checkpoint if files modified or chat is getting long

# Check if there are uncommitted changes
if [ -z "$(git status --short 2>/dev/null)" ]; then
  exit 0
fi

# Count commits in this branch since last merge to main
commits_since_main=$(git log main..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ -z "$commits_since_main" ]; then
  commits_since_main=0
fi

# Count commits since PROJECT_STATE.md was last updated
state_commit=$(git log --oneline -1 -- docs/PROJECT_STATE.md 2>/dev/null | awk '{print $1}')
if [ -n "$state_commit" ]; then
  commits_since_state=$(git log ${state_commit}..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
else
  commits_since_state=$commits_since_main
fi

# Suggest checkpoint
echo ""
if [ "$commits_since_state" -gt 5 ]; then
  echo "📌 $commits_since_state commits sin actualizar PROJECT_STATE."
  echo "   /checkpoint — guarda estado para no perder contexto"
else
  echo "📌 Archivos modificados. /checkpoint para guardar estado."
fi
echo "   /checkpoint quick — guardado rápido (mid-sesión)"
echo "   /checkpoint close — cierre completo + nuevo chat recomendado"
echo ""

# Long chat signal: approximate via commit activity density
# If many commits exist but session feels long, suggest new chat
if [ "$commits_since_main" -gt 10 ]; then
  echo "💡 Sesión larga detectada ($commits_since_main commits en esta rama)."
  echo "   Considera: /checkpoint close → nuevo chat → /new-session"
  echo "   (Chats largos consumen más tokens — dividir mejora velocidad)"
  echo ""
fi

exit 0
