Inicia la sesión de trabajo con objetivo claro.

El usuario escribió: /goal "$ARGUMENTS"

Ejecuta en este orden sin preguntar:

1. Lee CLAUDE.md del proyecto
2. Lee docs/ROADMAP.md
3. Lee docs/PROBLEMS.md (si existe)
4. Ejecuta en terminal: git status, git branch --show-current, git log --oneline -5
5. Revisa ~/.claude/CREDENCIALES.md — busca líneas con ⚠️

Responde con este formato exacto (sin secciones extra):

---
## Sesión — [fecha hoy]

**Objetivo:** [repite el objetivo del usuario]
**Branch actual:** [nombre del branch]

**Contexto del ROADMAP:**
[1-2 líneas de qué estaba pendiente según ROADMAP.md]

**Problemas relevantes ya resueltos:**
[Si PROBLEMS.md tiene algo relacionado con el objetivo de hoy → menciona 1-2 líneas: "Este tipo de problema ya se resolvió el [fecha]: [solución corta]"]
[Si no hay nada relevante → omite esta sección completamente]

**Plan concreto (máximo 4 pasos):**
1. [primer paso — específico, accionable]
2. [segundo]
3. [tercero si aplica]
4. [cuarto si aplica]

**Alertas (solo si existen):**
- [credencial con ⚠️ en CREDENCIALES.md]
- [si estás en branch main → "⚠️ Estás en main — crea un branch: git checkout -b work/descripcion"]
- [si el objetivo contradice el ROADMAP → menciona la discrepancia]
- [si el objetivo ya estaba en Completado del ROADMAP → avísalo antes del plan]

---

Reglas:
- No inventes estado — solo lo que los archivos confirman
- Si no hay ROADMAP.md → dilo y ofrece crearlo con /init-context
- Si el usuario escribe solo /goal sin argumento → pide el objetivo en una línea
