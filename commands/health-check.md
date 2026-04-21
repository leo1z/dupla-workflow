Auditoría rápida del sistema. Sin preguntas — analiza y reporta.

Ejecuta en este orden:

1. **CREDENCIALES** — Lee ~/.claude/CREDENCIALES.md
   - Lista todas las líneas con ⚠️

2. **SKILLS** — Auditoría de skills
   - Lista todos los archivos en ~/.claude/commands/
   - Lee ~/.claude/PROJECTS_SKILLS.md → extrae nombres de skills en tablas "Core Skills" e "Installed Plugins"
   - Compara: skills en commands/ vs skills registrados en PROJECTS_SKILLS.md
   - **Sin registrar:** skills en commands/ que NO están en PROJECTS_SKILLS.md → ⚠️ "agregar manualmente a ~/.claude/PROJECTS_SKILLS.md"
   - **Skills core mínimos requeridos:** new-session.md, new-project.md, progress.md, update-context.md, health-check.md, setup.md, adopt.md, token-budget.md
   - Plugins de terceros (ui-ux-pro-max, etc.) solo son error si están en PROJECTS_SKILLS.md pero no en commands/

3. **PROYECTO ACTIVO** (si hay carpeta de proyecto abierta)
   - Ejecuta: git branch --show-current, git status --short
   - Verifica que existe CLAUDE.md en la raíz
   - Verifica que existen: docs/PROJECT_STATE.md, docs/PROBLEMS.md
   - Busca archivos obsoletos: docs/KANBAN.md, docs/tier1.md, docs/WORKING_NOTES.md
   - Verifica presencia de: docs/ROADMAP.md, docs/ARCHITECTURE.md (esperados si proyecto avanzado)

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
