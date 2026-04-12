Inicia la sesión de trabajo con objetivo claro.

El usuario escribió: /goal "$ARGUMENTS"

Ejecuta en este orden sin preguntar:

1. Lee CLAUDE.md del proyecto
2. Lee docs/PROJECT_STATE.md (si no existe → leer docs/ROADMAP.md como fallback)
3. Lee docs/PROBLEMS.md (si existe)
4. Ejecuta en terminal: git status, git branch --show-current, git log --oneline -5

Responde con este formato exacto (sin secciones extra, máximo 15 líneas en total):

---
## Sesión — [fecha hoy]

**Objetivo:** [repite el objetivo del usuario]
**Branch actual:** [nombre del branch]

**Estado del proyecto:**
[1-2 líneas de qué estaba pendiente según PROJECT_STATE.md]

**Problemas relevantes ya resueltos:**
[Si PROBLEMS.md tiene algo relacionado con el objetivo → 1-2 líneas: "Este tipo de problema ya se resolvió: [solución corta]"]
[Si no hay nada relevante → omite esta sección completamente]

**Plan (máximo 4 pasos):**
1. [primer paso — específico y accionable]
2. [segundo]
3. [tercero si aplica]
4. [cuarto si aplica]

**Alertas (solo si existen):**
- [si estás en branch main → "⚠️ Estás en main — crea un branch: git checkout -b work/descripcion"]
- [si el objetivo contradice el PROJECT_STATE → menciona la discrepancia]
- [si el objetivo ya estaba en Completado → avísalo antes del plan]

---

Reglas:
- No inventes estado — solo lo que los archivos confirman
- Si no existe PROJECT_STATE.md ni ROADMAP.md → avisar y ofrecer crearlo: "No hay PROJECT_STATE.md. Corre /init-context para generarlo."
- Si el usuario escribe solo /goal sin argumento → pide el objetivo en una línea
- Respuesta máxima: 15 líneas. Sin headers extra, sin texto de relleno
