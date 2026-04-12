Inicia la sesión de trabajo con objetivo claro.

El usuario escribió: /goal "$ARGUMENTS"

Ejecuta en este orden sin preguntar:

1. Ejecuta: git branch --show-current, git log --oneline -8, git status --short
2. Lee docs/PROJECT_STATE.md si existe
3. Lee docs/PROBLEMS.md si existe y es relevante al objetivo

**Lógica de estado (en orden de confianza):**
- Si PROJECT_STATE.md existe Y el último commit es más reciente que su última modificación → el estado real está en git log, no en PROJECT_STATE.md. Usa git log como fuente primaria y PROJECT_STATE.md como contexto de fondo.
- Si PROJECT_STATE.md existe Y está actualizado → úsalo como fuente primaria.
- Si PROJECT_STATE.md no existe → infiere el estado solo desde git log. No pidas /init-context a menos que git log esté vacío.

Responde con este formato (máximo 12 líneas):

---
## Sesión — [fecha]

**Objetivo:** [lo que pidió el usuario]
**Branch:** [branch actual] [⚠️ si es main]

**Estado inferido:**
[1-2 líneas — qué se hizo según git log + PROJECT_STATE.md. Si hay discrepancia entre ambos, usar git log.]

**Plan:**
1. [paso concreto]
2. [paso concreto]
3. [si aplica]

**Alerta:** [solo si hay algo que bloquea — credencial, branch main, conflicto con PROJECT_STATE]
---

Reglas:
- Máximo 12 líneas. Sin texto de relleno.
- Si el usuario no pasó argumento → pregunta el objetivo en una sola línea.
- No exijas /progress anterior — infiere desde git.
