#!/bin/bash
# Instala los skills de Claude Code en ~/.claude/commands/

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Instalando skills en $COMMANDS_DIR..."

# Crear la carpeta si no existe
mkdir -p "$COMMANDS_DIR"

# Copiar todos los skills
cp "$SCRIPT_DIR/commands/"*.md "$COMMANDS_DIR/"

echo ""
echo "✓ Skills instalados:"
ls "$COMMANDS_DIR/"*.md | xargs -I{} basename {}

echo ""
echo "Próximos pasos:"
echo "  1. Copia templates/CLAUDE.global.md a ~/.claude/CLAUDE.md y edítalo"
echo "  2. Copia templates/CREDENCIALES.template.md a ~/.claude/CREDENCIALES.md y llénalo"
echo "  3. Abre un proyecto en VS Code y escribe /project-status para verificar"
