Auditoría rápida del sistema. Sin preguntas — analiza y reporta.

Ejecuta en este orden:

1. **CREDENCIALES** — Lee ~/.claude/CREDENCIALES.md
   - Lista todas las líneas con ⚠️

2. **SKILLS** — Lista archivos en ~/.claude/commands/
   - Verifica que existen: goal.md, progress.md, init-context.md, update-context.md, health-check.md
   - Si hay otros → mencionarlos como "terceros" (no son error)

3. **PROYECTO ACTIVO** (si hay carpeta de proyecto abierta)
   - Ejecuta: git branch --show-current, git status --short
   - Verifica que existe CLAUDE.md en la raíz
   - Verifica que existe docs/PROJECT_STATE.md
   - Busca archivos obsoletos: docs/ROADMAP.md, docs/KANBAN.md, docs/tier1.md, docs/WORKING_NOTES.md, docs/DECISIONS.md

4. **COHERENCIA DE STACK** (solo si hay proyecto abierto con package.json)
   - Lee package.json → extrae versiones principales
   - Lee CLAUDE.md sección Stack → compara
   - Reporta solo si hay diferencia mayor (versión major distinta)

Responde SOLO en este formato — sin secciones extra:

---
## Health Check — [fecha]

✅ **OK:** [lista en bullets lo que está bien]

⚠️ **Atención:** [lista con acción específica para cada item]

❌ **Crítico:** [lista con solución para cada item]

**Tiempo estimado para resolver todo:** [X minutos]
---

Reglas:
- Máximo 20 líneas en total
- Si todo está bien → solo el bloque ✅ y "Sistema OK"
- No leas archivos que no necesites — mínimo de tokens
