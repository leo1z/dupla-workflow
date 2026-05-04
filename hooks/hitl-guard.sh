#!/bin/bash
# Hook: PreToolUse (Bash) — Human-in-the-Loop guard for destructive commands
# Fires before any Bash tool execution. Blocks and demands explicit Y/N.
# OWASP Agent Security: prevents Tool Misuse and Goal Hijack side effects.

# Read stdin JSON — extract the command
# Fail-closed: if we cannot parse the input, block and warn rather than allow blindly.
STDIN_DATA=$(cat)
CMD=""

if command -v python3 >/dev/null 2>&1; then
  CMD=$(echo "$STDIN_DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('command', ''))
except:
    print('')
" 2>/dev/null)
elif command -v jq >/dev/null 2>&1; then
  CMD=$(echo "$STDIN_DATA" | jq -r '.tool_input.command // empty' 2>/dev/null)
else
  # No JSON parser available — cannot verify safety of this command.
  # Fail-closed: block and require user to install python3 or jq.
  echo ""
  echo "┌─────────────────────────────────────────────────────┐"
  echo "│  ⚠️  HITL — DEPENDENCIA FALTANTE                    │"
  echo "└─────────────────────────────────────────────────────┘"
  echo ""
  echo "  hitl-guard.sh no puede verificar la seguridad de este comando"
  echo "  porque python3 y jq no están disponibles."
  echo ""
  echo "  Política: BLOQUEADO por defecto (fail-closed)."
  echo "  Instala python3: https://python.org/downloads (marca 'Add to PATH')"
  echo "  O instala jq:    https://jqlang.github.io/jq/download/"
  echo ""
  echo "  Luego cierra y vuelve a abrir la terminal."
  exit 1
fi

if [ -z "$CMD" ]; then
  exit 0
fi

# --- DESTRUCTIVE PATTERN DETECTION ---
REASON=""
RISK=""

# git push to protected branches
if echo "$CMD" | grep -qE 'git push.*(main|master)'; then
  REASON="git push a rama protegida"
  RISK="Sube commits a producción — irreversible sin force-revert"
fi

# force push (any branch)
if echo "$CMD" | grep -qE 'git push.*--force|git push.*-f\b'; then
  REASON="git push --force"
  RISK="DESTRUCTIVO: sobreescribe historial remoto — puede perder commits de otros"
fi

# recursive delete
if echo "$CMD" | grep -qE 'rm\s+-[a-z]*r[a-z]*\s+|rm\s+--recursive'; then
  REASON="rm recursivo detectado"
  RISK="Elimina archivos/carpetas — irreversible"
fi

# database destructive ops
if echo "$CMD" | grep -qiE '\bDROP\s+TABLE\b|\bDELETE\s+FROM\b|\bTRUNCATE\b'; then
  REASON="operación destructiva en base de datos"
  RISK="Elimina datos — puede ser irreversible sin backup"
fi

# writes to global ~/.claude/ config
if echo "$CMD" | grep -qE '~/.claude/|$HOME/.claude/'; then
  REASON="modificación de configuración global ~/.claude/"
  RISK="Afecta todos los proyectos del usuario"
fi

# sudo escalation
if echo "$CMD" | grep -qE '^\s*sudo\b'; then
  REASON="escalación de privilegios con sudo"
  RISK="Ejecuta con permisos de root — impacto potencialmente global"
fi

# install scripts affecting all users
if echo "$CMD" | grep -qE 'bash\s+bin/install\.sh|bash\s+bin/'; then
  REASON="script de instalación global (bin/)"
  RISK="Modifica ~/.claude/, ~/.gemini/, ~/.cursor/ — afecta todos los proyectos"
fi

# No destructive pattern → allow
if [ -z "$REASON" ]; then
  exit 0
fi

# --- HITL BLOCK ---
echo ""
echo "┌─────────────────────────────────────────────────────┐"
echo "│  ⚠️  HITL — ACCIÓN DESTRUCTIVA DETECTADA            │"
echo "└─────────────────────────────────────────────────────┘"
echo ""
echo "  Razón:   $REASON"
echo "  Riesgo:  $RISK"
echo "  Comando: $CMD"
echo ""
echo "  Esta acción requiere aprobación explícita del usuario."
echo "  El agente debe PAUSAR y mostrar este aviso antes de continuar."
echo ""
echo "  → Presenta esto al usuario y espera confirmación [Y/N]"
echo "  → Solo Y o yes (explícito) permite continuar"
echo "  → Cualquier otra respuesta = ABORTAR"
echo ""

# Block execution — Claude Code will surface this output to the user
exit 1
