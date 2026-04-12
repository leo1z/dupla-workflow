#!/bin/bash
# Instala los skills de Claude Code y el script de nuevo proyecto

COMMANDS_DIR="$HOME/.claude/commands"
PROJECTS_DIR="$HOME/Projects"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Skills de Claude Code ────────────────────────────────────
echo "Instalando skills en $COMMANDS_DIR..."
mkdir -p "$COMMANDS_DIR"
cp "$SCRIPT_DIR/commands/"*.md "$COMMANDS_DIR/"

echo ""
echo "Skills instalados:"
ls "$COMMANDS_DIR/"*.md | xargs -I{} basename {}

# ── Script nuevo-proyecto.sh ─────────────────────────────────
echo ""
echo "Instalando nuevo-proyecto.sh en $PROJECTS_DIR..."
mkdir -p "$PROJECTS_DIR"
cp "$SCRIPT_DIR/nuevo-proyecto.sh" "$PROJECTS_DIR/nuevo-proyecto.sh"
chmod +x "$PROJECTS_DIR/nuevo-proyecto.sh"
echo "  ✓ nuevo-proyecto.sh listo en $PROJECTS_DIR"

# ── Templates ────────────────────────────────────────────────
echo ""
echo "Copiando templates a $PROJECTS_DIR/AI_CONTEXT_TEMPLATE/..."
mkdir -p "$PROJECTS_DIR/AI_CONTEXT_TEMPLATE"
cp "$SCRIPT_DIR/templates/"* "$PROJECTS_DIR/AI_CONTEXT_TEMPLATE/"
echo "  ✓ Templates copiados (incluye PLANNING_PROMPT.md)"

echo ""
echo "Próximos pasos:"
echo "  1. Copia templates/CLAUDE.global.md a ~/.claude/CLAUDE.md y edítalo con tu info"
echo "  2. Copia templates/CREDENCIALES.template.md a ~/.claude/CREDENCIALES.md y llénalo"
echo "  3. Para planificar un proyecto nuevo: lee AI_CONTEXT_TEMPLATE/PLANNING_PROMPT.md"
echo "  4. Para crear un proyecto:"
echo "       bash ~/Projects/nuevo-proyecto.sh                         (interactivo)"
echo "       bash ~/Projects/nuevo-proyecto.sh --config mi.config      (desde plan)"
echo "  5. Abre un proyecto en VS Code y escribe /goal \"test\" para verificar"
