#!/bin/bash
# instalar.sh — Instala dupla-workflow en una máquina nueva
# Copia skills a ~/.claude/commands/ y global-templates a ~/.claude/
# Después corre /setup en Claude para personalizar el sistema.
#
# Uso: bash instalar.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_DIR="$HOME/.claude"

echo ""
echo "======================================"
echo "  DUPLA WORKFLOW — Instalación"
echo "======================================"
echo ""

# ── CHECK DEPENDENCIAS ───────────────────────────────────────

echo "[0/3] Verificando dependencias..."

MISSING=0

if ! command -v git &> /dev/null; then
  echo "  ✗ git no encontrado — instalar desde https://git-scm.com"
  MISSING=1
else
  echo "  ✓ git $(git --version | awk '{print $3}')"
fi

if ! command -v code &> /dev/null; then
  echo "  ⚠ VS Code CLI no encontrado — instalar desde https://code.visualstudio.com"
  echo "    (opcional — puedes abrir VS Code manualmente)"
else
  echo "  ✓ VS Code CLI disponible"
fi

# Claude Code check
if ! command -v claude &> /dev/null; then
  echo "  ⚠ Claude Code no encontrado — instalar desde https://claude.ai/code"
  echo "    (requerido para usar los skills)"
else
  echo "  ✓ Claude Code disponible"
fi

if [ $MISSING -eq 1 ]; then
  echo ""
  echo "  Instala las dependencias faltantes y vuelve a correr este script."
  exit 1
fi

echo ""

# ── SKILLS → ~/.claude/commands/ ────────────────────────────

echo "[1/3] Instalando skills en $COMMANDS_DIR..."
mkdir -p "$COMMANDS_DIR"

COPIED=0
SKIPPED=0

for skill in "$SCRIPT_DIR/commands/"*.md; do
  name=$(basename "$skill")
  dest="$COMMANDS_DIR/$name"

  if [ -f "$dest" ]; then
    echo "  ↷ $name (ya existe — omitido)"
    SKIPPED=$((SKIPPED + 1))
  else
    cp "$skill" "$dest"
    echo "  ✓ $name"
    COPIED=$((COPIED + 1))
  fi
done

echo "  → $COPIED instalados, $SKIPPED omitidos"
echo ""

# ── GLOBAL TEMPLATES → ~/.claude/ ───────────────────────────

echo "[2/3] Copiando global-templates a $CLAUDE_DIR/..."
mkdir -p "$CLAUDE_DIR"

TEMPLATE_COPIED=0

for tpl in "$SCRIPT_DIR/global-templates/"*.md; do
  name=$(basename "$tpl")
  dest="$CLAUDE_DIR/$name"

  # Solo copiar si no existe (son templates — el usuario los personaliza con /setup)
  if [ -f "$dest" ]; then
    echo "  ↷ $name (ya existe — omitido)"
  else
    cp "$tpl" "$dest"
    echo "  ✓ $name"
    TEMPLATE_COPIED=$((TEMPLATE_COPIED + 1))
  fi
done

echo ""

# ── CREDENTIALS TEMPLATE ─────────────────────────────────────

echo "[3/3] Verificando CREDENCIALES.md..."
CREDS="$CLAUDE_DIR/CREDENCIALES.md"
CREDS_TEMPLATE="$SCRIPT_DIR/templates/CREDENTIALS_TEMPLATE.md"

if [ -f "$CREDS" ]; then
  echo "  ↷ CREDENCIALES.md ya existe — no se sobrescribe"
elif [ -f "$CREDS_TEMPLATE" ]; then
  cp "$CREDS_TEMPLATE" "$CREDS"
  echo "  ✓ CREDENCIALES.md creado desde template — llénalo con tus credenciales reales"
else
  echo "  ⚠ Template de credenciales no encontrado — crea $CREDS manualmente"
fi

echo ""

# ── RESULTADO ────────────────────────────────────────────────

echo "======================================"
echo "  ✓ Instalación completa"
echo "======================================"
echo ""
echo "Próximos pasos:"
echo ""
echo "  1. Abre cualquier proyecto en VS Code con Claude Code"
echo "  2. Escribe: /setup"
echo "     Claude te hará una entrevista y generará:"
echo "       ~/.claude/CLAUDE.md"
echo "       ~/.claude/CONTEXTO_[tu-nombre].md"
echo "       ~/.claude/STACK_GLOBAL.md"
echo "       ~/.claude/PROJECTS_SKILLS.md"
echo ""
echo "  3. Después del setup, corre: /health-check"
echo "     Verifica que todo está en orden."
echo ""
echo "  4. Para proyectos nuevos:"
echo "     bash nuevo-proyecto.sh   (desde esta carpeta o ruta completa)"
echo ""
echo "  5. Para adoptar un proyecto existente:"
echo "     Abre el proyecto en VS Code y escribe: /adopt"
echo ""
echo "  Docs del sistema: $SCRIPT_DIR/docs/"
echo ""
